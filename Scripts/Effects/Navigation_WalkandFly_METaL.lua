require("Actions")

osgnav.removeStandardNavigation()

RelativeTo.World:setMatrix(osg.Matrixd.translate(10, 3.5, 0))

local getRoomToWorld = function()
	return RelativeTo.World:getInverseMatrix()
end

local transformPointRoomToWorld = function(v)
	return getRoomToWorld():preMult(v)
end

local transformDirectionRoomToWorld = function(v)
	return getRoomToWorld():preMult(osg.Vec4d(v,0))
end


walking_nav = function(dt)
	local wand = gadget.PositionInterface('VJWand')
	local device = gadget.DigitalInterface("VJButton0")
	local dt = dt
	local rate = 1.5
	while true do
		repeat
			dt = Actions.waitForRedraw()
		until device.pressed
		while device.pressed do
			dt = Actions.waitForRedraw()
			-- Post-mult here does our movement in the room frame before the rest of the transform
			RelativeTo.World:postMult(osg.Matrixd.translate(-wand.forwardVector:x()*rate*dt,0,-wand.forwardVector:z()*rate*dt))
		end
	end

end
Actions.addFrameAction(walking_nav)

fly_nav = function(dt)
	local wand = gadget.PositionInterface('VJWand')
	local device = gadget.DigitalInterface("VJButton0")
	local dt = dt
	local rate = 1.5
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
	
function switchNavigationFromWalkingToFlying()
	Actions.removeFrameAction(walking_nav2)
	fly_nav2 = Actions.addFrameAction(fly_nav)
end

function switchNavigationFromFlyingToWalking()
	Actions.removeFrameAction(fly_nav2)
	walking_nav2 = Actions.addFrameAction(walking_nav)
end


Actions.addFrameAction(
	function()
		local toggle_button = gadget.DigitalInterface("WMButtonPlus")
		while true do
			repeat
				Actions.waitForRedraw()
			until toggle_button.justPressed
				switchNavigationFromWalkingToFlying()
			repeat
				Actions.waitForRedraw()
			until toggle_button.justPressed
				switchNavigationFromFlyingToWalking()
		end
	end
)
