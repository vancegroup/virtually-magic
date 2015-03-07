local ghostPresent = false

ghostAppear = function()
	while true do
		local wandPos = RelativeTo.World:getInverseMatrix():preMult(device.position)
		if (wandPos:x()> -13.3 and wandPos:x()< -11.1 and wandPos:z()< -10.5 and ghostPresent==false) then
			RelativeTo.World:addChild(boggart)
			ghostPresent = true
			PlayDementor()
			break
		end
		Actions.waitForRedraw()
	end
	Actions.addFrameAction(moveGhost)
end

moveGhost = function(dt)
	while true do
		if (ghostPresent==true and (((dementor:getPosition()):z())<24)) then
			dementor:setPosition(osg.Vec3d((dementor:getPosition()):x()+.95*dt, (dementor:getPosition()):y()-.3*dt, ((dementor:getPosition()):z()+ 4*dt--[[.25]])),1)
			dt = Actions.waitForRedraw()
		end
		Actions.waitForRedraw()
	end
end

Actions.addFrameAction(ghostAppear)