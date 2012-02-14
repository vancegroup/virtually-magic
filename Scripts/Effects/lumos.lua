--Lumos script; easily modifiable to serve as a simple flashlight; February 1, 2012
--Authors: Jane Peters, Nia Johnson, Leif Berg

require("Actions")
require("TransparentGroup")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
local device = gadget.PositionInterface("VJWand")

--Simple room models to demonstrate lighting capability.  
--TESTING AND DEBUGGING ONLY
room = Transform{
	position={0,0,0},
	orientation=AngleAxis(Degrees(-90), Axis{0.0,0.0,0.0}),
	scale=.1,
	Model([[../../Hogwarts Models/OSG/Room of Requirement/room of requirements.ive]]),
}
RelativeTo.World:addChild(room)

local stateSet = RelativeTo.World:getOrCreateStateSet()

--Create first light & lightsource
--Not required for lumos - serves as background lighting
local light1 = osg.Light()
local lightsource1 = osg.LightSource()
lightsource1:setLight(light1)

local light2 = osg.Light()
--Add if more than one light
light2:setLightNum(1)
local lightsource2 = osg.LightSource()
lightsource2:setLight(light2)

--Set ambient lighting - [R,G,B,A]
--Default: -- 0.05 0.05 0.05 1
--Set background lighting low
light1:setAmbient(osg.Vec4(0.2, 0.2, 0.2, 1))
--Set directed lighting to higher intensity
light2:setAmbient(osg.Vec4(0.7, 0.8, .9, 1))

--set diffuse lighting
light1:setDiffuse(osg.Vec4(.1, .1, .1, .5))
light2:setDiffuse(osg.Vec4(.1, .1, .3, .5))


--Set attenuation (different amounts of light depending on distance)
--Combine constant, linear and quadratic attenuation for desired effect
light1:setConstantAttenuation(.001)
light1:setLinearAttenuation(.05)

light2:setConstantAttenuation(.001)
light2:setLinearAttenuation(.00001)
--Adjust quadratic attenuation to impact depth of illumination
--NOTE: quadraticAttenuation give most realistic 
--	feel to the degree to which the light is attenuated
light2:setQuadraticAttenuation(.005)

--Set background light to always be present
lightsource1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
stateSet:setAssociatedModes(light1, osg.StateAttribute.Values.ON)
RelativeTo.World:addChild(lightsource1)
light1:setPosition(osg.Vec4(1, 4, -.25, 1.0))

--Set width of beam of directed light
--90 yeilds half sphere, 20 yeilds narrow beam
light2:setSpotCutoff(20)
--Set definition of beam edge
--A higher SpotExponent softens the light at the outer edges of the beam
light2:setSpotExponent(70)			
RelativeTo.World:addChild(lightsource2)

xform = osg.MatrixTransform()
RelativeTo.Room:addChild(xform)

updateXformPos = function()
	while true do
		xform:setMatrix(device.matrix)
		Actions.waitForRedraw()
	end
end

updateFlashLightPos = function()
	while true do
		local newPos = xform:getMatrix():getTrans()
		light2:setDirection(osg.Vec3(device.forwardVector:x(),device.forwardVector:y(),device.forwardVector:z()))
		light2:setPosition(osg.Vec4(newPos:x(), newPos:y(), (newPos:z()), 1.0))
		Actions.waitForRedraw()
	end
end
--Actions.addFrameAction(updateFlashLightPos)

lightONandOFF = function()
	local drawBtn = gadget.DigitalInterface("VJButton1")
	while true do
		--keep drawing scene until button pressed
		repeat
			Actions.waitForRedraw()
		until drawBtn.justPressed
		
		-- turn on the light
		lightsource2:setLocalStateSetModes(osg.StateAttribute.Values.ON)
		stateSet:setAssociatedModes(light2, osg.StateAttribute.Values.ON)
		
		--keep drawing scene until button pressed
		repeat
			Actions.waitForRedraw()
		until drawBtn.justPressed
	
		--turn off the light
		lightsource2:setLocalStateSetModes(osg.StateAttribute.Values.OFF)
		stateSet:setAssociatedModes(light2, osg.StateAttribute.Values.OFF)
	end
end

Actions.addFrameAction(updateFlashLightPos)
Actions.addFrameAction(lightONandOFF)
Actions.addFrameAction(updateXformPos)