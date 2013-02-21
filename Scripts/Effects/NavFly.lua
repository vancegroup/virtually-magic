require("Actions")

osgnav.removeStandardNavigation()

local getRoomToWorld = function()
	return RelativeTo.World:getInverseMatrix()
end

local transformPointRoomToWorld = function(v)
	return getRoomToWorld():preMult(v)
end

local transformDirectionRoomToWorld = function(v)
	return getRoomToWorld():preMult(osg.Vec4d(v,0))
end

Actions.addFrameAction(
	function(dt)
		local wand = gadget.PositionInterface('VJWand')
		local device = gadget.DigitalInterface("VJButton0")
		local dt = dt
		local rate = 3
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until device.pressed
			while device.pressed do
				dt = Actions.waitForRedraw()
				-- Post-mult here does our movement in the room frame before the rest of the transform
				RelativeTo.World:postMult(osg.Matrixd.translate(-wand.forwardVector*rate*dt))
			end
		end
	
	end
)