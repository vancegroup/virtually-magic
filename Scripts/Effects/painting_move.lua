require("Actions")
require("getScriptFilename")
fn = getScriptFilename()
vrjLua.appendToModelSearchPath(fn)

dofile(vrjLua.findInModelSearchPath([[MoveTools.lua]]))

painting = Transform{
	position={0,-.4,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.5,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/ladypainting.ive]]),
}
RelativeTo.World:addChild(painting)

painting_move = function()
	return function()
		while true do
				if ((track:x()> 2 and track:x()< 4 and track:z()> -21.5 and track:z()< -17 and (((painting:getPosition()):z())>-3))) then
					newPos = osg.Vec3d(-.01,-.4,-3)
					newPos = newPos - painting:getPosition()
					PlayPainting()
					func = Transformation.move_slow(painting,.2,newPos:x(),newPos:y(),newPos:z())
					func()
					Actions.waitForRedraw()
				elseif ((track:x()< 2 and track:z()< -21.5 and (((painting:getPosition()):z())<-2.9))) then
					newPos = osg.Vec3d(0,-.4,0)
					newPos = newPos - painting:getPosition()
					PlayPainting()
					func = Transformation.move_slow(painting,.2,newPos:x(),newPos:y(),newPos:z())
					func()
					Actions.waitForRedraw()
				end
			Actions.waitForRedraw()
		end
	end
end

Actions.addFrameAction(painting_move())