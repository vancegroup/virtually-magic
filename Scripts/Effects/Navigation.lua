require("Actions")
local FlyOrWalkNavigationIndex = { isFlyOrWalkNavigation = true }
local FlyOrWalkNavigationMT = {__index = FlyOrWalkNavigationIndex}
--disable current VRJuggLua navigation

--helper functions (not sure what to do with yet)
local getRoomToWorld = function()
	return RelativeTo.World:getInverseMatrix()
end

local transformPointRoomToWorld = function(v)
	return getRoomToWorld():preMult(v)
end

local transformDirectionRoomToWorld = function(v)
	return getRoomToWorld():preMult(osg.Vec4d(v, 0))
end

function FlyOrWalkNavigationIndex:startWalking()
	Actions.removeFrameAction(self.flying_frame_action_marker)
	if self.dropToGroundWhenWalking then
		local world_height = RelativeTo.World:getMatrix():getTrans():y()
		RelativeTo.World:preMult(osg.Matrixd.translate(0, -world_height, 0))
	end
	self.walking_frame_action_marker = Actions.addFrameAction(self.walk_frame_action)
	print("FlyOrWalkNavigation: Walking Mode Started")
end

function FlyOrWalkNavigationIndex:startFlying()
	Actions.removeFrameAction(self.walking_frame_action_marker)
	self.flying_frame_action_marker = Actions.addFrameAction(self.fly_frame_action)
	print("FlyOrWalkNavigation: Flying Mode Started")
end

function FlyOrWalkNavigationIndex:addSwitchButtonActionFrame()
	Actions.addFrameAction(self.switch_frame_action)
end

function FlyOrWalkNavigationIndex:startRotating()
	self.rotation_frame_action_maker = Actions.addFrameAction(self.rotation_frame_action)
end

function FlyOrWalkNavigationIndex:stopRotating()
	Actions.removeFrameAction(self.rotation_frame_action_maker)
end

function FlyOrWalkNavigationIndex:setup()
	self.walk_frame_action = function(dt)
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until self.moveButton.pressed
			while self.moveButton.pressed do
				dt = Actions.waitForRedraw()
				RelativeTo.World:postMult(osg.Matrixd.translate(-self.device.forwardVector:x() * self.rate * dt, 0, -self.device.forwardVector:z() * self.rate * dt))
			end
		end
	end
	self.fly_frame_action = function(dt)
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until self.moveButton.pressed
			while self.moveButton.pressed do
				dt = Actions.waitForRedraw()
				RelativeTo.World:postMult(osg.Matrixd.translate(-self.device.forwardVector * self.rate * dt))
			end
		end
	end
	if self.start == "flying" then
		self.switch_frame_action = function()
			while true do
				repeat
					Actions.waitForRedraw()
				until self.switchButton.justPressed
				self:startWalking()
				repeat
					Actions.waitForRedraw()
				until self.switchButton.justPressed
				self:startFlying()
			end
		end
		self:startFlying()
	else --if not flying then walking
		self.switch_frame_action = function()
			while true do
				repeat
					Actions.waitForRedraw()
				until self.switchButton.justPressed
				self:startFlying()
				repeat
					Actions.waitForRedraw()
				until self.switchButton.justPressed
				self:startWalking()
			end
		end
		self:startWalking()
	end
	self.rotation_frame_action = function()
		local function getWandForwardVectorWithoutY()
			return osg.Vec3d(self.device.forwardVector:x(), 0, self.device.forwardVector:z())
		end
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until self.initiateRotationButton1.pressed or self.initiateRotationButton2.pressed

			local initialWandForwardVector = getWandForwardVectorWithoutY()
			local maximumRotation = osg.Quat()
			local incrementalRotation = osg.Quat()

			while self.initiateRotationButton1.pressed or self.initiateRotationButton2.pressed do
				local dt = Actions.waitForRedraw()
				local newForwardVec = getWandForwardVectorWithoutY()
				maximumRotation:makeRotate(newForwardVec, initialWandForwardVector)
				incrementalRotation:slerp(dt * self.rotRate, osg.Quat(), maximumRotation)
				local newHeadPosition = RelativeTo.World:getInverseMatrix():preMult(self.head.position)
				local deltaMatrix = osg.Matrixd()
				deltaMatrix:preMult(osg.Matrixd.translate(newHeadPosition))
				deltaMatrix:preMult(osg.Matrixd.rotate(incrementalRotation))
				deltaMatrix:preMult(osg.Matrixd.translate(-newHeadPosition))
				RelativeTo.World:preMult(deltaMatrix)
			end
		end
	end
end

FlyOrWalkNavigation = function(nav)
	print("FlyOrWalkNavigation: removing standard navigation...")
	osgnav.removeStandardNavigation()
	nav.start = nav.start or "flying"
	nav.dropToGroundWhenWalking = nav.dropToGroundWhenWalking or true
	nav.rate = nav.rate or 1.5
	nav.rotRate = nav.rotRate or .5
	nav.device = nav.device or gadget.PositionInterface('VJWand')
	nav.moveButton = nav.moveButton or gadget.DigitalInterface("VJButton0")
	nav.head = nav.head or gadget.PositionInterface("VJHead")
	setmetatable(nav, FlyOrWalkNavigationMT)
	nav:setup()

	if nav.switchButton ~= nil then
		nav:addSwitchButtonActionFrame()
	else
		print("FlyOrWalkNavigation: No switchButton provided, won't be able to switch to walking mode")
	end

	if nav.initiateRotationButton1 ~= nil then
		nav.initiateRotationButton2 = nav.initiateRotationButton2 or nav.initiateRotationButton1
		nav:startRotating()
	else
		print("FlyOrWalkNavigation: No initiateRotationButton1 provided, you won't be able to rotate")
	end

	return nav
end