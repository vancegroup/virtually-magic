Actions.addFrameAction(function()
	function randomPos()
		local a = math.random()
		return {math.random(-3,3),math.random(1,4),math.random(-5,5)}
	end
	while true do
		newPos = osg.Vec3d(unpack(randomPos()))
		newPos = newPos - snitch:getPosition()
		func = Transformation.move_slow(snitch,3.5,newPos:x(),newPos:y(),newPos:z())
		func()
		Actions.waitSeconds(math.random(1.0,1.7))
		Actions.waitForRedraw()
	end
end)