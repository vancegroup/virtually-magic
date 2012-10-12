

--[[ The frame action connecting it all ]]--
navaction = nil

startNav = function(a)
	if navaction ~= nil then --not equal to
		--the frame action already exists
		Actions.removeFrameAction(navaction)
		navaction = nil
	else
		--the frame action doesn't exist yet
		osgnav.removeStandardNavigation()
		--hack based once relative to world is a Matrix Transform
		-- if navtransform then
		-- print "Adding hack."
		-- local oldWorld = RelativeTo.World
		-- navtransform:removeChild(RelativeTo.World)
		-- RelativeTo.World = osg.MatrixTransform()
		-- navtransform:addChild(RelativeTo.World)
		-- RelativeTo.World:addChild(oldWorld)
		-- end
	end
	local getNewMatrix = assert(a.NavigationFunction, "Must pass a NavigationFunction")
	local isNotColliding = a.CollisionDetectionFunction or function() return true end
	navaction = Actions.addFrameAction(
		function(dt)
			while true do
				local lastMatrix = RelativeTo.World:getMatrix()
				--print ("Last Matrix: " .. tostring(lastMatrix:getTrans()))
				local dt = Actions.waitForRedraw()
				local newMatrix = getNewMatrix(lastMatrix, dt)
				--print ("New Matrix: " .. tostring(newMatrix:getTrans()))
				if isNotColliding(newMatrix) then
					setSpeedFactor(0.05)
				else
					--print "Collision detected, not navigating this time!"
					setSpeedFactor(0.001)
				end
				RelativeTo.World:setMatrix(newMatrix)
			end
		end)
end
