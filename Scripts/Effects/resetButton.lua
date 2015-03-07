--[[ Action for returning to the starting position ]]
Actions.addFrameAction(
	function()
		while true do
			repeat
				Actions.waitForRedraw()
			until resetBtn.justPressed
				RelativeTo.World:setMatrix(osg.Matrixd.translate(10, 3.5, 0))
				ghostPresent = false
				RelativeTo.World:removeChild(boggart)
		end
	end
)