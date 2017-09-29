--on my board this is...
gpio2 = 1

-- Door switch contact interrupt callback
function switchcb(level)
  print("hit switch state for gpio"..gpio2)

  lvl = gpio.read(gpio2)

  if lvl == 1 then
    state = "CLOSED"
  else
    state = "OPEN"
  end

  print(state)

  -- Publish a message on each change in state
  --tmr.alarm(2, 1000, 0, function() m:publish(topic, state, 0, 0, function(conn) print("sent") end) end)
end

-- Configure GPIO2 as an interrupt with a pullup
gpio.mode(gpio2, gpio.INT, gpio.PULLUP)
-- Set GPIO2 to call our handler on both edges
gpio.trig(gpio2, "both", switchcb)
