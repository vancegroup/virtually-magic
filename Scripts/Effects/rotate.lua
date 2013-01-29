require("Actions")

osgnav.removeStandardNavigation()

Actions.addFrameAction(
	function(dt)
		local wand = gadget.PositionInterface('VJWand')
		local device = gadget.DigitalInterface("VJButton0")
		local dt = dt
		local rate = 1
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until device.pressed
			while device.pressed do
				dt = Actions.waitForRedraw()
				--Need to update wand.forwardVector after rotation has occurred 
				RelativeTo.World:preMult(osg.Matrixd.translate(-wand.forwardVector*.085))
			end
		end
	
	end
)

local head = gadget.PositionInterface("VJHead")
updateposTrack = function()
	while true do
		trackhead = RelativeTo.World:getInverseMatrix():preMult(head.position)
		Actions.waitForRedraw()
	end
end
Actions.addFrameAction(updateposTrack)

-- rotate to the right at 10 degrees per second, about the location of the head.
Actions.addFrameAction(
	function(dt)
		local device = gadget.DigitalInterface("VJButton1")
		--local device = gadget.DigitalInterface("WMButtonMinus")
		local dt = dt
		local rate = 10
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until device.pressed
			repeat
				local deltaMatrix = osg.Matrixd()
				deltaMatrix:preMult(osg.Matrixd.translate(trackhead))
				deltaMatrix:preMult(osg.Matrixd.rotate(AngleAxis(Degrees(rate * dt), Vec(0, -1, 0))))
				deltaMatrix:preMult(osg.Matrixd.translate(-trackhead))
				RelativeTo.World:preMult(deltaMatrix)
				dt = Actions.waitForRedraw()
			until not device.pressed
		end
	
	end
)

--[[
Actions.addFrameAction(
	function(dt)
		local wand = gadget.PositionInterface("VJWand")
		local device = gadget.DigitalInterface("WMButtonMinus")
		--local device = gadget.DigitalInterface("VJButton2")
		local dt = dt
		local rate = 1
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until device.pressed
			
			local wandForward = wand.forwardVector
			local rotateMax = osg.Quat()
			local incRotate = osg.Quat()

			while device.pressed do
				-- first, wait for next frame
				dt = Actions.waitForRedraw()
				
				-- See where they point now.
				local newForwardVec = wand.forwardVector
				
				-- Try to make those pointing places the same - rotate one to the other
				rotateMax:makeRotate(newForwardVec, wandForward)
				
				-- slerp scales our incremental rotation by dt
				incRotate:slerp(dt * rate, osg.Quat(), rotateMax)
				
				local deltaMatrix = osg.Matrixd()
				deltaMatrix:preMult(osg.Matrixd.translate(-wand.position))
				deltaMatrix:preMult(osg.Matrixd.rotate(incRotate))
				deltaMatrix:preMult(osg.Matrixd.translate(wand.position))

				RelativeTo.World:preMult(deltaMatrix)
			end
		end
	
	end
)
]]