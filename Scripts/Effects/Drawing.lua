require("Actions")

local DrawingIndex = { isDrawing = true}
local DIMT = { __index = DrawingIndex }

local SphereMarker = function(a)
	local pos = osg.Vec3(0.0, 0.0, 0.0)
	if a.position then
		pos:set(unpack(a.position))
	end
	local sphere = osg.Sphere(pos, a.radius or 1.0)
	local drbl = osg.ShapeDrawable(sphere)
	local color = osg.Vec4(0,0,0,1)
	if a.color then
		color:set(unpack(a.color))
	end
	drbl:setColor(color)
	local geode = osg.Geode()
	geode:addDrawable(drbl)
	return geode
end

local getRainbowColor = coroutine.wrap(function()
	while true do
		coroutine.yield(osg.Vec4(255/255, 0, 0, 1))
		coroutine.yield(osg.Vec4(255/255, 127/255, 0, 1))
		coroutine.yield(osg.Vec4(255/255, 255/255, 0, 1))
		coroutine.yield(osg.Vec4(0, 255/255, 0, 1))
		coroutine.yield(osg.Vec4(0, 0, 255/255, 1))
		coroutine.yield(osg.Vec4(111/255, 0, 255/255, 1))
		coroutine.yield(osg.Vec4(143/255, 0, 255/255, 1))
	end
end)

function DrawingIndex:updateMarker()
	self.marker.Child[1] = SphereMarker{radius = .1, color = self.color}
end

function DrawingIndex:createOSG()
	self.osg = Transform{}
	self.marker_osg = osg.MatrixTransform()
	self.marker_osg:addChild(self.marker)
	self:updateMarker()
	RelativeTo.World:addChild(self.osg)
	RelativeTo.Room:addChild(self.marker_osg)	
end

function DrawingIndex:changeColor(new_color)
	if new_color == nil then
		local vec = getRainbowColor()
		new_color = {vec:x(),vec:y(),vec:z(), 1}
	end
	self.color = new_color
	self:updateMarker()
end

function DrawingIndex:changeLineWidth(new_line_width)
	self.linewidth = new_line_width
end

function DrawingIndex:clearDrawing()
	self.osg:removeChildren(0,self.osg:getNumChildren())
end

function DrawingIndex:startDrawing()
	--add drawing frame action - REQUIRED
	Actions.addFrameAction(
		function()
			while true do
				repeat
					Actions.waitForRedraw()
				until self.drawbutton.justPressed
				local vertices, colors, linestrip, geom = self:drawNewLine()
				while self.drawbutton.pressed do
					local pos = RelativeTo.World:getInverseMatrix():preMult(self.device.position)
					self:addPoint(osg.Vec3(pos:x(), pos:y(), pos:z()), vertices, colors, linestrip, geom)
					Actions.waitForRedraw()
				end
				geom:setUseDisplayList(true)
			end
		end
	)
	--add markerpos frame action - REQUIRED
	Actions.addFrameAction(function()
		while true do
			self.marker_osg:setMatrix(self.device.matrix)
			Actions.waitForRedraw()
		end
	end
	)
	
	if self.clear_func then
		--add clearbutton frame action - OPTIONAL
		Actions.addFrameAction(
		function()
			while true do
				repeat
					Actions.waitForRedraw()
				until self.clearbutton.justPressed
				self:clearDrawing()
			end
		end
		)
	end

	if self.changeColor_func == true then
		--add change color frame action - OPTIONAL
		Actions.addFrameAction(
		function()
			while true do
				repeat
					Actions.waitForRedraw()
				until self.changeColor_button.justPressed
				self:changeColor()
			end
		end
		)
	end
end

function DrawingIndex:drawNewLine()
	local geom = osg.Geometry()
	geom:setUseDisplayList(false)
	local geode = osg.Geode()
	geode:addDrawable(geom)
	self.osg:addChild(geode)
	local vertices = osg.Vec3Array()
	geom:setVertexArray(vertices)
	local colors = osg.Vec4Array()
	geom:setColorArray(colors)
	geom:setColorBinding(osg.Geometry.AttributeBinding.BIND_PER_VERTEX)
	local linestrip = osg.DrawArrays(osg.PrimitiveSet.Mode.LINE_STRIP)
	geom:addPrimitiveSet(linestrip)
	local stateRoot = geom:getOrCreateStateSet()
	local lw = osg.LineWidth(self.linewidth)
	stateRoot:setAttribute(lw)
	return vertices, colors, linestrip, geom
end

function DrawingIndex:addPoint(vertex, vertices, colors, linestrip, geom)
	vertices.Item:insert(vertex)
	if self.rainbow then
		colors.Item:insert(getRainbowColor())
	else
		colors.Item:insert(osg.Vec4(self.color[1], self.color[2], self.color[3], 1))
	end
	linestrip:setCount(#(vertices.Item))
	geom:setVertexArray(vertices)
end

DrawingTool = function(draw)
	if draw.clear_func == nil then
		draw.clear_func = true
	end
	if draw.changeColor_func == nil then
		draw.changeColor_func = true
	end
	draw.device = draw.device or gadget.PositionInterface("VJWand")
	if draw.metal then
		print("Using default METAL devices")
		if draw.drawbutton == nil and draw.clearbutton == nil and draw.changeColor_button == nil then
			print("Using default workstation devices")
			print("Home - Clear Drawing")
			print("Plus - Change Color")
			print("Trigger (B) - Draw")
		end
		draw.drawbutton = draw.drawbutton or gadget.DigitalInterface("WMButtonB")
		draw.clearbutton = draw.clearbutton or gadget.DigitalInterface("WMButtonHome")
		draw.changeColor_button = draw.changeColor_button or gadget.DigitalInterface("VJButtonPlus")
	else
		if draw.drawbutton == nil and draw.clearbutton == nil and draw.changeColor_button == nil then
			print("Using default workstation devices")
			print("Left Mouse - Clear Drawing")
			print("Middle Mouse - Change Color")
			print("Right Mouse - Draw")
		end
		draw.drawbutton = draw.drawbutton or gadget.DigitalInterface("VJButton2")
		draw.clearbutton = draw.clearbutton or gadget.DigitalInterface("VJButton0")
		draw.changeColor_button = draw.changeColor_button or gadget.DigitalInterface("VJButton1")
	end
	draw.color = draw.color or {1,1,0,1}
	draw.marker = Transform{SphereMarker{radius = .1, color = draw.color}}
	draw.linewidth = draw.linewidth or 10 
	setmetatable(draw, DIMT)
	draw:createOSG()
	return draw
end