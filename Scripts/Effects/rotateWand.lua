require("Actions")

local head = gadget.PositionInterface("VJHead")
updateposTrack = function()
	while true do
		trackhead = RelativeTo.World:getInverseMatrix():preMult(head.position)
		Actions.waitForRedraw()
	end
end
Actions.addFrameAction(updateposTrack)

Actions.addFrameAction(
	function(dt)
		local wand = gadget.PositionInterface("VJWand")
		--local device = gadget.DigitalInterface("WMButtonLeft")
		--local device2 = gadget.DigitalInterface("WMButtonRight")
		local device = gadget.DigitalInterface("VJButton2")
		local dt = dt
		local rate = .5
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until device.pressed
			
			local wandForward = osg.Vec3d(wand.forwardVector:x(),0,wand.forwardVector:z())
			local rotateMax = osg.Quat()
			local incRotate = osg.Quat()

			while device.pressed do
				-- first, wait for next frame
				dt = Actions.waitForRedraw()
				
				-- See where they point now.
				local newForwardVec = osg.Vec3d(wand.forwardVector:x(),0,wand.forwardVector:z())
				
				-- Try to make those pointing places the same - rotate one to the other
				rotateMax:makeRotate(newForwardVec, wandForward)
				
				-- slerp scales our incremental rotation by dt
				incRotate:slerp(dt * rate, osg.Quat(), rotateMax)
				
				local deltaMatrix = osg.Matrixd()
				deltaMatrix:preMult(osg.Matrixd.translate(trackhead))
				deltaMatrix:preMult(osg.Matrixd.rotate(incRotate))
				deltaMatrix:preMult(osg.Matrixd.translate(-trackhead))

				RelativeTo.World:preMult(deltaMatrix)
			end
		end
	
	end
)

