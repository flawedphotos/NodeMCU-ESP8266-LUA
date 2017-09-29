WIFI_SSID = "stuff"
WIFI_PASS = "junk"

require("wifi_events");

function startup()
    if file.open("init.lua") == nil then
        print("init.lua deleted or renamed")
    else
        print("Running")
        file.close("init.lua")
        -- the actual application is stored in 'application.lua'
        -- dofile("application.lua")
    end
end

-- Register WiFi Station event callbacks
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifi_disconnect_event)

print("Connecting to WiFi access point...")
print(wifi.sta.getip())
wifi.setmode(wifi.STATION)

--Fill Your SSID and PASSWORD
--connect to Access Point (DO NOT save config to flash)
station_cfg={}
station_cfg.ssid=WIFI_SSID
station_cfg.pwd=WIFI_PASS
wifi.sta.config(station_cfg)

wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
     if wifi.sta.getip() == nil then
         print("Connecting...")
     else
         tmr.stop(1)
         print("Connected, IP is "..wifi.sta.getip())
     end
end)

dofile("simple_http_server.lua")
dofile("sensor_monitor.lua")
