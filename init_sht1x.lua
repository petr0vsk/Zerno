-- load SID and Password
dofile("credential.lua")
-- if any thing done wrong - delete init.lua
function startup()
  if file.open("init.lua") == nil then
    print("-- init.lua deleted --")
  else
    print("-- Running --")
    file.close("init.lua")
  end
end
----init esp8266 --------
print("-- Set up wi-fi mode --")
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID, PASSWORD)
wifi.sta.autoconnect(1)
-- check connect
tmr.alarm(1,1000,tmr.ALARM_AUTO, function()
  if wifi.sta.getip() == nil then
    print("-- IP unavailable, Waiting... --")
  else
    tmr.stop(1)
    print("ESP8266  mode is: " .. wifi.getmode())
    print("MAC address is: ".. wifi.ap.getmac())
    print("IP  address is: " .. wifi.sta.getip())
    print("-- You have 5 second to abort Startup --")
    print("-- Waiting --")
    --wifi.sta.getap(listap)
    dofile("mqtt.lua")
  end
end)

collectgarbage()
function run()
  data = dofile("sht1x_v2.lua")
  temp = (data[1])
  hum  = (data[2])
  print("temp: "..temp, "humm: "..hum)
	data = nil
	temp = nil
	hum = nil
	btemp = nil
	collectgarbage()
	--tmr.alarm(0, 200, 0, function() print("========") end)
end
tmr.alarm(0, 1000, 1, run)
