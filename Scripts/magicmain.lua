require("Actions")
require("TransparentGroup")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[Effects/lumos.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/draw.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/hiddenSwitch.lua]]))
local device = gadget.PositionInterface("VJWand")

--Button Descriptions:
--A:"name(METaL)=WMButtonA":"name(Computer)=VJButton0":flying effect
--B:"name(METaL)=WMButtonB":"name(Computer)=VJButton1":drawing effect
--Plus:"name(METaL)=WMButtonPlus":"name(Computer)=":lumos effect
--Minus:"name(METaL)=WMButtonMinus":"name(Computer)="
--Home:"name(METaL)=WMButtonHome":"name(Computer)=":clear drawing

roomRequirement = Transform{
	position={4.5,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/room of requirements expanded.ive]]),
}
RelativeTo.World:addChild(roomRequirement)

