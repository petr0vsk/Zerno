----------------------------------------
--- mqtt client for SHT1x sensor
-----------------------------------------

-- connect to mqtt broker at    https://www.cloudmqtt.com/
m = mqtt.Client("clientid"..node.chipid(), 120, "XXX", "XXXX")
m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)
print("mqtt.lua")
-- connect to cloud broker and resive temp and hum --
m:connect("m20.cloudmqtt.com", 11448, 0, function(client)
  print("connected")
-- subscribe topic with qos = 0
  client:subscribe("test", 0, function(client) print("subscribe success") end)
  -- publish a message with data = hello, QoS = 0, retain = 0
  client:publish("test", "hello from ESP82661 SHT1x sensor", 0, 0, function(client) print("sent") end)
end,

function(client, reason)
  print("failed reason: " .. reason)
end)

function publish_data()
  data = dofile("sht1x_v2.lua")
  temp = (data[1])
  hum = (data[2])
  m:publish("test",temp, 0,0, function(conn)
  print("Temp "..temp.." Hum "..hum)
  data = nil
	temp = nil
	hum = nil
	btemp = nil
	collectgarbage()
  end)
end

--
tmr.alarm(2, 6000, 1, publish_data)
