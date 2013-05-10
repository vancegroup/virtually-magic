--New Navigation which encompasses flying, walking, and rotation for METaL. 
--Alicia Fleege 5-7-2013

require("Actions")

osgnav.removeStandardNavigation()

--Change starting location of application (not needed if used in other applications)
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

--Update the position of the tracked wii-mote
local device = gadget.PositionInterface("VJWand")
updatepositionTrack = function()
	while true do
		track = RelativeTo.World:getInverseMatrix():preMult(device.position)
		Actions.waitForRedraw()
	end
end
Actions.addFrameAction(updatepositionTrack)

--Function for walking in scene
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

--Function for flying in scene
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
	
--Functions for switching between navigation styles.
function switchNavigationFromWalkingToFlying()
	Actions.removeFrameAction(walking_nav2)
	fly_nav2 = Actions.addFrameAction(fly_nav)
end
function switchNavigationFromFlyingToWalking()
	Actions.removeFrameAction(fly_nav2)
	RelativeTo.World:preMult(osg.Matrixd.translate(0, track:y()-height, 0))
	walking_nav2 = Actions.addFrameAction(walking_nav)
end

--FrameAction for using the wii-mote to switch between navigation styles. 
Actions.addFrameAction(
	function()
		local toggle_button = gadget.DigitalInterface("WMButtonPlus")
		while true do
			repeat
				Actions.waitForRedraw()
				height = track:y()
			until toggle_button.justPressed
				switchNavigationFromWalkingToFlying()
			repeat
				Actions.waitForRedraw()
			until toggle_button.justPressed
				switchNavigationFromFlyingToWalking()
		end
	end
)

--Update the position of the tracked head
local head = gadget.PositionInterface("VJHead")
updateposTrack = function()
	while true do
		trackhead = RelativeTo.World:getInverseMatrix():preMult(head.position)
		Actions.waitForRedraw()
	end
end
Actions.addFrameAction(updateposTrack)

--Add Rotation to the Scene
Actions.addFrameAction(
	function(dt)
		local wand = gadget.PositionInterface("VJWand")
		local device = gadget.DigitalInterface("WMButtonLeft")
		local device2 = gadget.DigitalInterface("WMButtonRight")
		local dt = dt
		local rate = .5
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until device.pressed or device2.pressed
			
			local wandForward = osg.Vec3d(wand.forwardVector:x(),0,wand.forwardVector:z())
			local rotateMax = osg.Quat()
			local incRotate = osg.Quat()

			while device.pressed or device2.pressed do
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