local deviceManager = require "telldus.DeviceManager"

local LUMINANCE = 512
local SCALE_LUMINANCE_LUX = 1

function onDeviceStateChanged(device, state, stateValue)
	--print("Device changed %s, %s, %s", device:name(), state, stateValue)
	if device:name() == "Taklampa" and (state == 1 or state == 16) then
		local lightSensor = deviceManager:findByName("Vardagsrummet")
		local lux = lightSensor:sensorValue(LUMINANCE , SCALE_LUMINANCE_LUX)
		dimLamp(device, lux)
	end
end

function onSensorValueUpdated(device, valueType, value, scale)
	--print("Sensor changed %s, %s, %s, %s", device:name(), valueType, value, scale)

	local lamp = deviceManager:findByName("Taklampa")
	local lampState, lampStateValue = lamp:state()

	if device:id() == 8 and (lampState == 1 or lampState == 16) then
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
