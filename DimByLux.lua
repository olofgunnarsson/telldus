local deviceManager = require "telldus.DeviceManager"

local LIGHT_SENSOR = "ls"
local HUE_LIGHT_GROUP = "hlg"

local LUMINANCE = 512
local SCALE_LUMINANCE_LUX = 1

local ON = 1
local DIMMED = 16

function onDeviceStateChanged(device, state, stateValue)
	if device:name() == HUE_LIGHT_GROUP and state == ON then
		local lightSensor = deviceManager:findByName(LIGHT_SENSOR)
		local lux = lightSensor:sensorValue(LUMINANCE , SCALE_LUMINANCE_LUX)
		dimLamp(device, lux)
	end
end

function onSensorValueUpdated(device, valueType, value, scale)
	local lamp = deviceManager:findByName(HUE_LIGHT_GROUP)
	local lampState, lampStateValue = lamp:state()

	if device:name() == LIGHT_SENSOR and (lampState == ON or lampState == DIMMED) then
		dimLamp(lamp, value)
	end
end

function dimLamp(lamp, value)
	if value > 1000 then
		print("Set lamp to 200")
		lamp:command("dim", 200, "DimByLux.lua")
	else
		local newDim = math.floor((value*2) / 10)
		print("Set lamp to %s", newDim)
		lamp:command("dim", newDim, "DimByLux.lua")
	end
end
