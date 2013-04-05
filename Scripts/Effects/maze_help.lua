require("Actions")
require("TransparentGroup")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())

mazehelp = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/maze_help.ive]]),
}

Actions.addFrameAction(
	function()
		local device = gadget.PositionInterface("VJWand")
		--local helpBtn=gadget.DigitalInterface("VJButton2")
		local helpBtn=gadget.DigitalInterface("WMButton2")
		while true do
			repeat
				Actions.waitForRedraw()
			until helpBtn.justPressed
				ss = mazehelp:getOrCreateStateSet()
				ss:setMode(0x0B50,osg.StateAttribute.Values.OFF)
				RelativeTo.World:addChild(mazehelp)
				Actions.waitSeconds(5)
				RelativeTo.World:removeChild(mazehelp)
		end	
	end
)