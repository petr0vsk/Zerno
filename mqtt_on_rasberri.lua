----------------------------------------
--- mqtt client for SHT1x sensor
-----------------------------------------

-- connect to mqtt broker at    https://www.cloudmqtt.com/
m = mqtt.Client("SHT_TOP"..node.chipid(), 120)
m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)
print("mqtt.lua")
-- connect to Lan broker and resive temp and hum --
m:connect(BROKER_IP, 1883, 0, function(client) print("connected") end,

function(client, reason)
  print("failed reason: " .. reason)
end)

function publish_data() ---------
  data = dofile("sht1x_v2.lua")
  temp = (data[1])
  hum  = (data[2])
  print("Temp "..temp.." Hum "..hum)
  m:publish("/SHT/TEMP/TOP",temp, 0,0, function(conn)  end)
  m:publish("/SHT/HUM/TOP",hum, 0,0,  function(conn)   end)
  data = nil
	temp = nil
	hum = nil
	btemp = nil
	collectgarbage()
end
--
tmr.alarm(2, 6000, 1, publish_data)
