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
	Model([[../../Hogwarts Models/OSG/Room of Requirement/complete_room.ive]]),
}
RelativeTo.World:addChild(roomRequirement)

wardrobe = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/wardrobeback2.ive]]),
}
RelativeTo.World:addChild(wardrobe)

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

ladyPainting = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/ladypainting.ive]]),
}
snitch = Transform{
	position={1,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/snitch.ive]]),
}
RelativeTo.World:addChild(snitch)

updatepositionTrack = function()
	while true do
		track = device.position - osgnav.position
		Actions.waitForRedraw()
	end
end

ghostPresent = false

ghostAppear = function()
	while true do
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


moveGhost = function(dt)
	while true do
			if (ghostPresent==true and (((dementor:getPosition()):z())<24)) then
				dementor:setPosition(osg.Vec3d((dementor:getPosition()):x()+.95*dt, (dementor:getPosition()):y()-.04*dt, ((dementor:getPosition()):z()+ 4.2*dt--[[.25]])),1)
				dt = Actions.waitForRedraw()
			end
		Actions.waitForRedraw()
	end
end

Actions.addFrameAction(updatepositionTrack)
Actions.addFrameAction(ghostAppear)

paintingPresent = false

paintingAppear = function()
	while true do
			if (paintingPresent==false) then
				RelativeTo.World:addChild(ladyPainting)
				paintingPresent = true
				break
			end
		Actions.waitForRedraw()
	end
	Actions.addFrameAction(moveladyPainting)
end

moveladyPainting = function(dt)
	while true do
			if ((track:x()> 2 and track:x()< 6 and track:z()> -23 and track:z()< -19 and (((ladyPainting:getPosition()):z())>-3))) then
				ladyPainting:setPosition(osg.Vec3d((ladyPainting:getPosition()):x(), (ladyPainting:getPosition()):y(), ((ladyPainting:getPosition()):z()-.12*dt)))
				dt = Actions.waitForRedraw()
			end
		Actions.waitForRedraw()
	end
end

Actions.addFrameAction(paintingAppear)
-- Actions.addFrameAction(printPos)

