require("getScriptFilename")
require("Actions")
vrjLua.appendToModelSearchPath(getScriptFilename())

drawXform = Transform{}
RelativeTo.World:addChild(drawXform)

--add a wiimote clear button (home button)
Actions.addFrameAction(
	function()
		local device = gadget.PositionInterface("VJWand")
		local drawBtn = gadget.DigitalInterface("WMButtonHome")
		while true do
			repeat
				Actions.waitForRedraw()
			until drawBtn.justPressed
			drawXform:removeChildren(0,drawXform:getNumChildren())
		end
	end
)

do
	function drawNewLine(lineWidth)
		local geom = osg.Geometry()
		geom:setUseDisplayList(false)
		local geode = osg.Geode()
		geode:addDrawable(geom)
		drawXform:addChild(geode)
		local vertices = osg.Vec3Array()
		geom:setVertexArray(vertices)
		local colors = osg.Vec4Array()
		geom:setColorArray(colors)
		geom:setColorBinding(osg.Geometry.AttributeBinding.BIND_PER_VERTEX)
		local linestrip = osg.DrawArrays(osg.PrimitiveSet.Mode.LINE_STRIP)
		geom:addPrimitiveSet(linestrip)
		-- setting line width
		local stateRoot = geom:getOrCreateStateSet()
		local lw = osg.LineWidth(lineWidth)
		stateRoot:setAttribute(lw)
		return vertices,colors,linestrip,geom
	end

	getColor = coroutine.wrap(function()
		while true do
			coroutine.yield(osg.Vec4(1, 0, 0, 1))
			coroutine.yield(osg.Vec4(0, 1, 0, 1))
			coroutine.yield(osg.Vec4(0, 0, 1, 1))
		end
	end)


	function addPoint(v, vertices, colors, linestrip, geom)
		vertices.Item:insert(v)
		colors.Item:insert(getColor())
		linestrip:setCount(#(vertices.Item))
		geom:setVertexArray(vertices)
	end

	Actions.addFrameAction(
		function()
			--local drawBtn = gadget.DigitalInterface("WMButtonB")
			--local device = gadget.PositionInterface("VJWand")
			local drawBtn = gadget.DigitalInterface("VJButton1")
			local device = gadget.PositionInterface("VJWand")

			while true do
				repeat
					Actions.waitForRedraw()
				until drawBtn.justPressed

				local width = 10 --math.random(5,20)
				local vertices, colors, linestrip, geom = drawNewLine(width)

				while drawBtn.pressed do
					PlayDraw()
					local pos = RelativeTo.World:getInverseMatrix():preMult(device.position)
					addPoint(osg.Vec3(pos:x(), pos:y(), pos:z()), vertices, colors, linestrip, geom)
					Actions.waitForRedraw()
				end
				
				--OK, that line has been finalized, we can use display lists now.
				geom:setUseDisplayList(true)
			end
		end
	)
end