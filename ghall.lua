require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile([[C:\Users\jpeters\Desktop\Attempt1\simpleLights.lua]])

greatHall =Transform{
	scale = 1.0,
	 Transform{ position = {0,0,0},	orientation = AngleAxis(Degrees(90), Axis{0.0, 1.0, 0.0}),
 Model([[greathall.osg]])}
	 }
	 
		RelativeTo.World:addChild(greatHall)
