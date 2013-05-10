--Lumos script; easily modifiable to serve as a simple flashlight; March 13, 2013

require("Actions")
require("TransparentGroup")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
local device = gadget.PositionInterface("VJWand")

local stateSet = RelativeTo.World:getOrCreateStateSet()

--Create first light & lightsource
--Not required for lumos - serves as background lighting
light1 = osg.Light()
--light1:setLightNum(0)
lightsource1 = osg.LightSource()
lightsource1:setLight(light1)

--Creat lumos/"flashlight" effect
light2 = osg.Light()
--Add if more than one light
light2:setLightNum(1)
lightsource2 = osg.LightSource()
lightsource2:setLight(light2)

--Regular lighting for when lumos is not in effect
light3 = osg.Light()
light3:setLightNum(2)
lightsource3 = osg.LightSource()
lightsource3:setLight(light3)

light4 = osg.Light()
light4:setLightNum(3)
lightsource4 = osg.LightSource()
lightsource4:setLight(light4)

--Set ambient lighting - [R,G,B,A]
--Default: -- 0.05 0.05 0.05 1
--Set background lighting low
light1:setAmbient(osg.Vec4(0.1, 0.1, 0.1, .5))
--Set directed lighting to higher intensity
light2:setAmbient(osg.Vec4(.6,.9,1,.5))
--Set regular background to higher intensity
light3:setAmbient(osg.Vec4(.3, .3, 0.3, 1))
light4:setAmbient(osg.Vec4(.3, .3, 0.3, 1))

--set diffuse lighting
light1:setDiffuse(osg.Vec4(.1, .1, .1, .5))
light2:setDiffuse(osg.Vec4(.3,.7,.9,.5))
light3:setDiffuse(osg.Vec4(.8, .8, .8, 1))
light4:setDiffuse(osg.Vec4(.8, .8, .8, 1))

--Set attenuation (different amounts of light depending on distance)
--Combine constant, linear and quadratic attenuation for desired effect
light2:setConstantAttenuation(.21)
light2:setLinearAttenuation(.0025)
light2:setQuadraticAttenuation(.00009)
light3:setConstantAttenuation(.7)
light4:setConstantAttenuation(.7)

--set Position
light1:setPosition(osg.Vec4(2,3,8, 1.0))
light3:setPosition(osg.Vec4(10,2,8, 1.0))
light4:setPosition(osg.Vec4(-18,4,-50, 1.0))

--Set background light to always be present
lightsource1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
stateSet:setAssociatedModes(light1, osg.StateAttribute.Values.ON)
lightsource3:setLocalStateSetModes(osg.StateAttribute.Values.ON)
stateSet:setAssociatedModes(light3, osg.StateAttribute.Values.ON)
lightsource4:setLocalStateSetModes(osg.StateAttribute.Values.ON)
stateSet:setAssociatedModes(light4, osg.StateAttribute.Values.ON)
RelativeTo.World:addChild(lightsource1)
RelativeTo.World:addChild(lightsource3)
RelativeTo.World:addChild(lightsource4)

--Set width of beam of directed light
--90 yeilds half sphere, 20 yeilds narrow beam
light2:setSpotCutoff(6)
--Set definition of beam edge
--A higher SpotExponent softens the light at the outer edges of the beam
light2:setSpotExponent(100)			
RelativeTo.World:addChild(lightsource2)

updateposTrack = function()
	while true do
		local track = RelativeTo.World:getInverseMatrix():preMult(device.position)
		light2:setPosition(osg.Vec4(track:x(),track:y(),track:z(),1))
		light2:setDirection(osg.Vec3(device.forwardVector:x(),device.forwardVector:y(),device.forwardVector:z()))
		Actions.waitForRedraw()
	end
end
Actions.addFrameAction(updateposTrack)

lightONandOFF = function()
	--local drawBtn = gadget.DigitalInterface("VJButton1")
	local drawBtn = gadget.DigitalInterface("WMButtonUp")
	while true do
		-- keep drawing scene until button pressed
		repeat
			Actions.waitForRedraw()
		until drawBtn.justPressed
		-- lumos sound effect
			PlayLumos()
		-- turn on the light
			lightsource2:setLocalStateSetModes(osg.StateAttribute.Values.ON)
			stateSet:setAssociatedModes(light2, osg.StateAttribute.Values.ON)
			lightsource3:setLocalStateSetModes(osg.StateAttribute.Values.OFF)
			stateSet:setAssociatedModes(light3, osg.StateAttribute.Values.OFF)
			lightsource4:setLocalStateSetModes(osg.StateAttribute.Values.OFF)
			stateSet:setAssociatedModes(light4, osg.StateAttribute.Values.OFF)					
		-- keep drawing scene until button pressed
		repeat
			Actions.waitForRedraw()
		until drawBtn.justPressed
			offLumos()
		-- turn off the light
			lightsource2:setLocalStateSetModes(osg.StateAttribute.Values.OFF)
			stateSet:setAssociatedModes(light2, osg.StateAttribute.Values.OFF)
			lightsource3:setLocalStateSetModes(osg.StateAttribute.Values.ON)
			stateSet:setAssociatedModes(light3, osg.StateAttribute.Values.ON)
			lightsource4:setLocalStateSetModes(osg.StateAttribute.Values.ON)
			stateSet:setAssociatedModes(light4, osg.StateAttribute.Values.ON)		
		end
end

Actions.addFrameAction(lightONandOFF)
