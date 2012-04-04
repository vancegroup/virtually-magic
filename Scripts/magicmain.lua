require("Actions")
require("TransparentGroup")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[Effects/lumos.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/draw.lua]]))
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

hiddenDoor = Transform{
	position={4.5,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/hiddenbookshelf.ive]]),
}
RelativeTo.World:addChild(hiddenDoor)


positionTrack = osg.MatrixTransform()
RelativeTo.Room:addChild(positionTrack)

updatepositionTrack = function()
	while true do
		positionTrack:setMatrix(device.matrix)
		Actions.waitForRedraw()
	end
end

hiddenSwitch1 = function()
	while true do
		track = positionTrack:getMatrix():getTrans()
		--Remove hidden door
			if (track:x()> 3.09 and track:x()< 4.2 and track:z()> -2.61 and track:z()< -1.37 ) then
				RelativeTo.World:removeChild(hiddenDoor)
				print("Open!")
				break
			end
		Actions.waitForRedraw()
		-- --Add hidden door
			-- if (newPos:x()> and newPos:x()< and newPos:z()> and newPos:z()< ) then
				-- RelativeTo.Room:addChild(hiddenDoor)
				-- break
		-- Actions.waitForRedraw()
	end
end

Actions.addFrameAction(updatepositionTrack)
Actions.addFrameAction(hiddenSwitch1)
