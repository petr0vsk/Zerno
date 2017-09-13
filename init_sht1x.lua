
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
