require("Actions")
require("TransparentGroup")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[Effects/lumos_METaL.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/draw_METaL.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/hiddenSwitch.lua]]))
local device = gadget.PositionInterface("VJWand")

--Button Descriptions:
--A:"name(METaL)=WMButtonA":"name(Computer)=VJButton0":flying effect
--B:"name(METaL)=WMButtonB":"name(Computer)=VJButton1":drawing effect
--Plus:"name(METaL)=WMButtonPlus":"name(Computer)=":lumos effect
--Minus:"name(METaL)=WMButtonMinus":"name(Computer)="
--Home:"name(METaL)=WMButtonHome":"name(Computer)=":clear drawing

roomRequirement = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/room of requirements expanded.ive]]),
}
RelativeTo.World:addChild(roomRequirement)

wardrobe = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/wardrobe.ive]]),
}
RelativeTo.World:addChild(wardrobe)

dementor = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/ghost1.ive]]),
}

boggart = TransparentGroup{
	alpha = .7,
	dementor
}
--RelativeTo.World:addChild(boggart)

updatepositionTrack = function()
	while true do
		track = device.position - osgnav.position
		Actions.waitForRedraw()
	end
end

ghostPresent = false

ghostAppear = function()
	while true do
		--Remove hidden door
			if (track:x()> -13.3 and track:x()< -11.1 and track:z()< -11 and ghostPresent==false) then
				RelativeTo.World:addChild(boggart)
				print("Boo!")
				ghostPresent = true
				break
			end
		Actions.waitForRedraw()
	end
	Actions.addFrameAction(moveGhost)
	print("Go!")
end


moveGhost = function()
	while true do
		--Re-add hidden door
			if (ghostPresent==true and (((dementor:getPosition()):z())<24)) then
				dementor:setPosition(osg.Vec3d((dementor:getPosition()):x(), (dementor:getPosition()):y(), ((dementor:getPosition()):z()+.2)),1)
				--dementor:setScale(osg.Vec3d((((dementor:getScale()):x())*1.01),(((dementor:getScale()):y())*1.01),(((dementor:getScale()):z())*1.2)),1)
				Actions.waitForRedraw()
			end
		Actions.waitForRedraw()
	end
	--Necessary to add, otherwise, will never re-open
end

Actions.addFrameAction(updatepositionTrack)
Actions.addFrameAction(ghostAppear)
--Actions.addFrameAction(hiddenSwitch1OFF)
