print("Starting sensor monitor...")

require("consts");
require("sensor_data_to_influxdb");

-- Door switch contact interrupt callback
function switchcb(level)
  print("hit switch state")

  lvl = gpio.read(SENSOR_PIN)

  if lvl == SENSOR_STATUS_CODE_OPEN then
    print("OPEN")
    sendData(TAG_VAL_DOMAIN_PROD, SENSOR_DOOR_NUMBER, SENSOR_STATUS_CODE_OPEN)
  else
    print("CLOSED")
    sendData(TAG_VAL_DOMAIN_PROD, SENSOR_DOOR_NUMBER, SENSOR_STATUS_CODE_CLOSE)
  end

  -- Publish a message on each change in state
  --tmr.alarm(2, 1000, 0, function() m:publish(topic, state, 0, 0, function(conn) print("sent") end) end)
end

-- Configure SENSOR_PIN as an interrupt with a pullup
gpio.mode(SENSOR_PIN, gpio.INT, gpio.PULLUP)
-- Set SENSOR_PIN to call our handler on both edges
gpio.trig(SENSOR_PIN, "both", switchcb)

tmr.alarm(0, SENSOR_TIMER_FIRE_MS, tmr.ALARM_AUTO, switchcb)
