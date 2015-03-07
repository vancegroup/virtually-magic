local isOpen = false

hiddenSwitch1ON = function()
	while true do
		local wandPos = RelativeTo.World:getInverseMatrix():preMult(device.position)
		if (wandPos:x()> -9.95 and wandPos:x()< -7.3 and wandPos:z()> -20.3 and wandPos:z()< -18.1 ) then
			PlayBookshelf()
			RelativeTo.World:removeChild(hiddenDoor)
			isOpen = true
			break
		end
		Actions.waitForRedraw()
	end
	Actions.addFrameAction(hiddenSwitch1OFF)
end

hiddenSwitch1OFF = function()
	while true do
		local wandPos = RelativeTo.World:getInverseMatrix():preMult(device.position)
		if (wandPos:x()< -2.8 and (wandPos:z()< -20.3 or wandPos:z()> -18.1 ) and (isOpen == true)) then
			PlayBookshelf()
			RelativeTo.World:addChild(hiddenDoor)
			isOpen=false
			break
		end
		Actions.waitForRedraw()
	end
	Actions.addFrameAction(hiddenSwitch1ON)
end

Actions.addFrameAction(hiddenSwitch1ON)
Actions.addFrameAction(hiddenSwitch1OFF)


