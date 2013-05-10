require("Actions")
require("TransparentGroup")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())

dofile(vrjLua.findInModelSearchPath([[Effects/Navigation.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/lumos.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/hiddenSwitch.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/snitchmove.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/painting_move.lua]]))
dofile(vrjLua.findInModelSearchPath([[BackgroundSound.lua]]))
--dofile(vrjLua.findInModelSearchPath([[Effects/help.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/Drawing.lua]]))
dofile(vrjLua.findInModelSearchPath([[Effects/maze_help.lua]]))

--startBackgroundSound()
mydraw = DrawingTool{}
mydraw:startDrawing()

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

ghostPresent = false

Actions.addFrameAction(
	function()
		while true do
				if (track:x()> -13.3 and track:x()< -11.1 and track:z()< -10.5 and ghostPresent==false) then
					RelativeTo.World:addChild(boggart)
					print("Boo!")
					ghostPresent = true
					PlayDementor()
					break
				end
			Actions.waitForRedraw()
		end
		Actions.addFrameAction(moveGhost)
		print("Go!")
	end
)

moveGhost = function(dt)
	while true do
			if (ghostPresent==true and (((dementor:getPosition()):z())<24)) then
				dementor:setPosition(osg.Vec3d((dementor:getPosition()):x()+.95*dt, (dementor:getPosition()):y()-.3*dt, ((dementor:getPosition()):z()+ 4*dt--[[.25]])),1)
				dt = Actions.waitForRedraw()
			end
		Actions.waitForRedraw()
	end
end

--[[ Action for returning to the starting position ]]
Actions.addFrameAction(
	function()
		local toggle_button = gadget.DigitalInterface("WMButtonHome")
		--local toggle_button = gadget.DigitalInterface("VJButton1")
		while true do
			repeat
				Actions.waitForRedraw()
			until toggle_button.justPressed
				RelativeTo.World:setMatrix(osg.Matrixd.translate(10, 3.5, 0))
				ghostPresent = false
				RelativeTo.World:removeChild(boggart)
		end
	end
)