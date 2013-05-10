require("Actions")
require("getScriptFilename")
fn = getScriptFilename()
vrjLua.appendToModelSearchPath(fn)

dofile(vrjLua.findInModelSearchPath([[MoveTools.lua]]))

--This would be your Tranform / Model for the snitch
snitch = Transform{
	position={1,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/snitch.ive]]),
}

--Add the snitch to the world
RelativeTo.World:addChild(snitch)

snitch_move = function()
	local randomPos = function()
		local a = math.random()
		return {math.random(-3,3),math.random(1,4),math.random(-5,5)}
	end
	return function()
		while true do
			newPos = osg.Vec3d(unpack(randomPos()))
			newPos = newPos - snitch:getPosition()
			--print(newPos)
			func = Transformation.move_slow(snitch,3.5,newPos:x(),newPos:y(),newPos:z())
			func()
			--the next line adjusts a random value the snitch will wait, from .5 to 1.2 seconds - feel free to change these values
			Actions.waitSeconds(math.random(1.0,1.7))
			Actions.waitForRedraw()
		end
	end
end

--add the frame action to the simulation
Actions.addFrameAction(snitch_move())



