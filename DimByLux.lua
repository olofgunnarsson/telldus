local deviceManager = require "telldus.DeviceManager"

function onSensorValueUpdated(device, valueType, value, scale)
	print("Something changed %s, %s, %s, %s, %s", device:name(), device:id(), valueType, value, scale)
	
	if device:id() == 8 then
		local lamp = deviceManager:findByName("Taklampa")
		if value > 1000 then
			print("Set lamp to 100")
			lamp:command("dim", 100, nil)
		else
			local newDim = math.floor(value / 10)
			print("Set lamp to %s", newDim)
			lamp:command("dim", newDim, nil)
		end
	end
end

