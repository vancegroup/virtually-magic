Actions.addFrameAction(
	function()
		while true do
			repeat
				Actions.waitForRedraw()
			until helpMenuBtn.justPressed
				ss = mazehelp:getOrCreateStateSet()
				ss:setMode(0x0B50,osg.StateAttribute.Values.OFF)
				RelativeTo.World:addChild(mazehelp)
			repeat
				Actions.waitForRedraw()
			until helpMenuBtn.justPressed
				RelativeTo.World:removeChild(mazehelp)
		end	
	end
)