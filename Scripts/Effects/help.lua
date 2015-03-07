require("gldef")

Actions.addFrameAction(
	function()
		while true do
			repeat
				Actions.waitForRedraw()
			until helpMenuBtn.justPressed
				ss = wiihelp:getOrCreateStateSet()
				ss:setMode(0x0B50,osg.StateAttribute.Values.OFF)
				RelativeTo.Room:addChild(wiihelp)
			repeat
				Actions.waitForRedraw()
			until helpMenuBtn.justPressed
				RelativeTo.Room:removeChild(wiihelp)
		end
	end
)