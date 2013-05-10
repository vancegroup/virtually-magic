
local function _createTransformation(xform,upper_bound,lower_bound,rate, get, set)
	assert(lower_bound<upper_bound,"_createTransformation: assert failed: Invalid upper & lower bounds")
	local f = function()
		local dt = Actions.waitForRedraw()
		local pos_edit = get(xform)
		local upper = pos_edit + upper_bound
		local lower = pos_edit + lower_bound
	
		while true do		
			-- Go up to upper_bound
			while pos_edit < upper do
				pos_edit = pos_edit + dt * rate
				set(xform, pos_edit)
				dt = Actions.waitForRedraw()
			end
			-- Go all the way down to lower_bound
			while pos_edit > lower do
				pos_edit = pos_edit - dt * rate
				set(xform, pos_edit)
				dt = Actions.waitForRedraw()
			end
		end
	end
	return f
end

Transformation = {
	move_slow = function(xform,rate,x,y,z)
		local f = function()
			local pos = xform:getPosition()
			local dt = Actions.waitForRedraw()
			local goal = osg.Vec3d(pos:x()+x,pos:y()+y,pos:z()+ z)
			rate = rate or .5
			local distance_to_travel = (goal - pos):length()
			while true do 
				local currentPos = xform:getPosition()
				local newPos = (goal - pos) * dt*rate + currentPos
				local could_travel = (newPos - currentPos):length()
				if (could_travel > distance_to_travel) then
					newPos = (goal - pos) * distance_to_travel + currentPos	
					xform:setPosition(newPos)
					break
				else
					xform:setPosition(newPos)
					distance_to_travel = distance_to_travel - could_travel
				end
				dt = Actions.waitForRedraw()
			end
			xform:setPosition(goal)
		end
		return f
	end,
	move = function(xform,x,y,z)
		local move_to = osg.Vec3d(x,y,z)
		xform:setPosition(move_to)
	end,
	oscillateX = function(xform,upper_bound,lower_bound,rate)
		local function getter(xform)
			return xform:getPosition():x()
		end
		local function setter(xform, newval)
			local pos = xform:getPosition()
			xform:setPosition(osg.Vec3d(newval, pos:y(), pos:z()))
		end
		return _createTransformation(xform,upper_bound,lower_bound,rate,getter,setter)		
	end,
	oscillateY = function(xform,upper_bound,lower_bound,rate)
		local function getter(xform)
			return xform:getPosition():y()
		end
		local function setter(xform, newval)
			local pos = xform:getPosition()
			xform:setPosition(osg.Vec3d(pos:x(), newval, pos:z()))
		end
		return _createTransformation(xform,upper_bound,lower_bound,rate,getter,setter)		
	end,
	oscillateZ = function(xform,upper_bound,lower_bound,rate)
		local function getter(xform)
			return xform:getPosition():z()
		end
		local function setter(xform, newval)
			local pos = xform:getPosition()
			xform:setPosition(osg.Vec3d(pos:x(), pos:z(), newval))
		end
		return _createTransformation(xform,upper_bound,lower_bound,rate,getter,setter)		
	end,
}

