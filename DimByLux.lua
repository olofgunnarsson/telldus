local deviceManager = require "telldus.DeviceManager"
local lastDim = 0

function onDeviceStateChanged(device, state, stateValue)
	--print("Device changed %s, %s, %s", device:name(), state, stateValue)
	if device:name() == "Taklampa" and (state == 1 or state == 16) then
		print("Set lamp to %s", lastDim)
		lamp:command("dim", lastDim, "DimByLux.lua")
	end
end

function onSensorValueUpdated(device, valueType, value, scale)
	--print("Sensor changed %s, %s, %s, %s", device:name(), valueType, value, scale)

	local lamp = deviceManager:findByName("Taklampa")
	local lampState, lampStateValue = lamp:state()

	if device:id() == 8 and (lampState == 1 or lampState == 16) then
		lastReportedLux = value
		if value > 1000 then
			print("Set lamp to 100")
			lamp:command("dim", 100, "DimByLux.lua")
			lastDim = 100
		else
			local newDim = math.floor(value / 10)
			print("Set lamp to %s", newDim)
			lamp:command("dim", newDim, "DimByLux.lua")
			lastDim = newDim
		end
	end
end
