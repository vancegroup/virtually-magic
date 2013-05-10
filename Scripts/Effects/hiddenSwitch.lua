require("Actions")
require("TransparentGroup")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
local device = gadget.PositionInterface("VJWand")

hiddenDoor = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/hiddenbookshelf.ive]]),
}
RelativeTo.World:addChild(hiddenDoor)
isOpen = false

updatepositionTrack = function()
	while true do
		track = RelativeTo.World:getInverseMatrix():preMult(device.position)
		--track = device.position - osgnav.position
		Actions.waitForRedraw()
	end
end

hiddenSwitch1ON = function()
	while true do
		--Remove hidden door
			if (track:x()> -9.95 and track:x()< -7.3 and track:z()> -20.3 and track:z()< -18.1 ) then
				PlayBookshelf()
				RelativeTo.World:removeChild(hiddenDoor)
				print("Open!")
				isOpen = true
				break
			end
		Actions.waitForRedraw()
	end
	Actions.addFrameAction(hiddenSwitch1OFF)
end


hiddenSwitch1OFF = function()
	while true do
		--Re-add hidden door
			if (track:x()< -2.8 and (track:z()< -20.3 or track:z()> -18.1 ) and (isOpen == true)) then
				PlayBookshelf()
				RelativeTo.World:addChild(hiddenDoor)
				print("Close!")
				isOpen=false
				break
			end
		Actions.waitForRedraw()
	end
	Actions.addFrameAction(hiddenSwitch1ON)
	--Necessary to add, otherwise, will never re-open
end

-- For debugging purposes, DO NOT USE in demo mode, slows program down considerably
-- printPos = function()
	-- local checkPos = gadget.DigitalInterface("WMButtonB")
	-- while true do
		-- --keep drawing scene until button pressed
		-- repeat
			-- Actions.waitForRedraw()
		-- until checkPos.justPressed
			-- print(track)
		-- end
-- end
			

Actions.addFrameAction(updatepositionTrack)
Actions.addFrameAction(hiddenSwitch1ON)
Actions.addFrameAction(hiddenSwitch1OFF)
--Actions.addFrameAction(printPos)

