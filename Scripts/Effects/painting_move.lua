Actions.addFrameAction(function()
	while true do
		local wandPos = RelativeTo.World:getInverseMatrix():preMult(device.position)
		if ((wandPos:x()> 2 and wandPos:x()< 4 and wandPos:z()> -21.5 and wandPos:z()< -17 and (((painting:getPosition()):z())>-3))) then
			newPos = osg.Vec3d(-.01,-.4,-3)
			newPos = newPos - painting:getPosition()
			PlayPainting()
			func = Transformation.move_slow(painting,.2,newPos:x(),newPos:y(),newPos:z())
			func()
			Actions.waitForRedraw()
		elseif ((wandPos:x()< 2 and wandPos:z()< -21.5 and (((painting:getPosition()):z())<-2.9))) then
			newPos = osg.Vec3d(0,-.4,0)
			newPos = newPos - painting:getPosition()
			PlayPainting()
			func = Transformation.move_slow(painting,.2,newPos:x(),newPos:y(),newPos:z())
			func()
			Actions.waitForRedraw()
		end
		Actions.waitForRedraw()
	end
end)