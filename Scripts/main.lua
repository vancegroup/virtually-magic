require("TransparentGroup")
require("gldef")
require("AddAppDirectory")
AddAppDirectory()

device = gadget.PositionInterface("VJWand")

runfile[[Effects/buttonMappings.lua]]
runfile[[Effects/MoveTools.lua]]
runfile[[Effects/Navigation.lua]]
runfile[[Effects/lumos.lua]]
runfile[[Effects/hiddenSwitch.lua]]
runfile[[Effects/snitchmove.lua]]
runfile[[Effects/painting_move.lua]]
runfile[[Effects/BackgroundSound.lua]]
runfile[[Effects/help.lua]]
runfile[[Effects/Drawing.lua]]
runfile[[Effects/maze_help.lua]]
runfile[[Effects/resetButton.lua]]
runfile[[Effects/ghost.lua]]

mydraw = DrawingTool{
	metal = true,
	drawbutton = drawBtn,
	clearbutton = drawClrBtn,
	changeColor_button = drawChColorBtn,
}
mydraw:startDrawing()

myNav = FlyOrWalkNavigation{
	start = "walking",
	switchButton = navSwitchBtn,
	initiateRotationButton1 = navRotate1,
	initiateRotationButton2 = navRotate2,
}

local roomRequirement = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/complete_room.ive]]),
}

local wardrobe = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/wardrobeback2.ive]]),
}
dementor = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/boggart.ive]]),
}

boggart = TransparentGroup{
	alpha = .7,
	dementor
}

hiddenDoor = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/hiddenbookshelf.ive]]),
}

painting = Transform{
	position = {0,-.4,0},
	orientation = AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale = .5,
	Model[[../../Hogwarts Models/OSG/Room of Requirement/ladypainting.ive]],
}

snitch = Transform{
	position={1,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/snitch.ive]]),
}

mazehelp = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/maze_help.ive]]),
}

wiihelp = Transform{
	position={0,1.3,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/wiimote.ive]]),
}
local ss_wiihelp = wiihelp:getOrCreateStateSet()
ss_wiihelp:setMode(gldef.GL_LIGHTING, osg.StateAttribute.Values.OFF)
-- This line makes it so that it draws over everything (except apparently 
-- transparent stuff like the frusta)
ss_wiihelp:setMode(gldef.GL_DEPTH_TEST, osg.StateAttribute.Values.OFF)
-- This line makes it draw after the transparent things.
ss_wiihelp:setRenderingHint(osg.StateSet.RenderingHint.TRANSPARENT_BIN)
-- This changes the render order - see http://forum.openscenegraph.org/viewtopic.php?t=9884
-- The number is just an arbitrarily large number, while RenderBin is the sorting method.
ss_wiihelp:setRenderBinDetails(100, "RenderBin")


RelativeTo.World:addChild(snitch)
RelativeTo.World:addChild(painting)
RelativeTo.World:addChild(hiddenDoor)
RelativeTo.World:addChild(wardrobe)
RelativeTo.World:addChild(roomRequirement)