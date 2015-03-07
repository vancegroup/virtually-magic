require("TransparentGroup")

local stateSet = RelativeTo.World:getOrCreateStateSet()

function setupLight1()
	light1 = osg.Light()
	--light1:setLightNum(0)
	lightsource1 = osg.LightSource()
	lightsource1:setLight(light1)
	light1:setAmbient(osg.Vec4(0.1, 0.1, 0.1, .5))
	light1:setDiffuse(osg.Vec4(.1, .1, .1, .5))
	light1:setPosition(osg.Vec4(2,3,8, 1.0))
	lightsource1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	stateSet:setAssociatedModes(light1, osg.StateAttribute.Values.ON)
end

function setupLight2()
	light2 = osg.Light()
	light2:setLightNum(1)
	lightsource2 = osg.LightSource()
	lightsource2:setLight(light2)
	light2:setAmbient(osg.Vec4(.6,.9,1,.5))
	light2:setDiffuse(osg.Vec4(.3,.7,.9,.5))
	light2:setConstantAttenuation(.21)
	light2:setLinearAttenuation(.0025)
	light2:setQuadraticAttenuation(.00009)
	light2:setSpotCutoff(6)
	light2:setSpotExponent(100)			
end

function setupLight3()
	light3 = osg.Light()
	light3:setLightNum(2)
	lightsource3 = osg.LightSource()
	lightsource3:setLight(light3)
	light3:setAmbient(osg.Vec4(.3, .3, 0.3, 1))
	light3:setDiffuse(osg.Vec4(.8, .8, .8, 1))
	light3:setConstantAttenuation(.7)
	light3:setPosition(osg.Vec4(10,2,8, 1.0))
	lightsource3:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	stateSet:setAssociatedModes(light3, osg.StateAttribute.Values.ON)
end

function setupLight4()
	light4 = osg.Light()
	light4:setLightNum(3)
	lightsource4 = osg.LightSource()
	lightsource4:setLight(light4)
	light4:setAmbient(osg.Vec4(.3, .3, 0.3, 1))
	light4:setDiffuse(osg.Vec4(.8, .8, .8, 1))
	light4:setConstantAttenuation(.7)
	light4:setPosition(osg.Vec4(-18,4,-50, 1.0))
	lightsource4:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	stateSet:setAssociatedModes(light4, osg.StateAttribute.Values.ON)
end

setupLight1()
setupLight2()
setupLight3()
setupLight4()

RelativeTo.World:addChild(lightsource1)
RelativeTo.World:addChild(lightsource2)
RelativeTo.World:addChild(lightsource3)
RelativeTo.World:addChild(lightsource4)

--Update Lumos Position and Direction
Actions.addFrameAction(function()
	while true do
		local wandPos = RelativeTo.World:getInverseMatrix():preMult(device.position)
		light2:setPosition(osg.Vec4(wandPos:x(),wandPos:y(),wandPos:z(),1))
		light2:setDirection(osg.Vec3(device.forwardVector:x(),device.forwardVector:y(),device.forwardVector:z()))
		Actions.waitForRedraw()
	end
end)

--Lumos On/Off Button
Actions.addFrameAction(function()
	while true do
		repeat
			Actions.waitForRedraw()
		until lumosBtn.justPressed
			PlayLumos()
			lightsource2:setLocalStateSetModes(osg.StateAttribute.Values.ON)
			stateSet:setAssociatedModes(light2, osg.StateAttribute.Values.ON)
			lightsource3:setLocalStateSetModes(osg.StateAttribute.Values.OFF)
			stateSet:setAssociatedModes(light3, osg.StateAttribute.Values.OFF)
			lightsource4:setLocalStateSetModes(osg.StateAttribute.Values.OFF)
			stateSet:setAssociatedModes(light4, osg.StateAttribute.Values.OFF)					
		repeat
			Actions.waitForRedraw()
		until lumosBtn.justPressed
			offLumos()
			lightsource2:setLocalStateSetModes(osg.StateAttribute.Values.OFF)
			stateSet:setAssociatedModes(light2, osg.StateAttribute.Values.OFF)
			lightsource3:setLocalStateSetModes(osg.StateAttribute.Values.ON)
			stateSet:setAssociatedModes(light3, osg.StateAttribute.Values.ON)
			lightsource4:setLocalStateSetModes(osg.StateAttribute.Values.ON)
			stateSet:setAssociatedModes(light4, osg.StateAttribute.Values.ON)		
	end
end)