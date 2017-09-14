--------------------------------
-- init file for sensor base on SHT1x chip
-----------------------------------
WIFI_SSID = "Zerno_IoT"
WIFI_PASS = "28Shik0mba"
MQTT_BrokerIP = "192.168.1.2"
MQTT_BrokerPort = 1883
MQTT_ClientID = "sht-top"
--MQTT_Client_user = "user"
--MQTT_Client_password = "password"
--DHT_PIN = 7

wifi.setmode(wifi.STATION)
wifi.sta.config(WIFI_SSID, WIFI_PASS)
wifi.sta.connect()

local wifi_status_old = 0

tmr.alarm(0, 5000, 1, function()
    print("tmr0 "..wifi_status_old.." "..wifi.sta.status())

    if wifi.sta.status() == 5 then -- подключение есть
        if wifi_status_old ~= 5 then -- Произошло подключение к Wifi, IP получен
            print(wifi.sta.getip())

            m = mqtt.Client(MQTT_ClientID, 120)

            -- Определяем обработчики событий от клиента MQTT
            m:on("connect", function(client) print ("connected") end)
            m:on("offline", function(client)
                tmr.stop(1)
                print ("offline")
            end)
            m:on("message", function(client, topic, data)
                print(topic .. ":" )
                if data ~= nil then
                    print(data)
                end
            end)

            m:connect(MQTT_BrokerIP, MQTT_BrokerPort, 0, 1, function(conn)
                print("connected")

                -- Подписываемся на топики если нужно
                --m:subscribe("/var/#",0, function(conn)
                --end)

                tmr.alarm(1, 3000, 1, function()
                    -- Делаем измерения, публикуем их на брокере
                    local status,temp,humi,temp_decimal,humi_decimal = dht.read(DHT_PIN)

                    if (status == dht.OK) then
                        print("Temp: "..temp.."."..temp_decimal.." C")
                        print("Hum: "..humi.."."..humi_decimal.." %")
                        m:publish("/ESP/DHT/TEMP", temp.."."..temp_decimal, 0, 0, function(conn) print("sent") end)
                        m:publish("/ESP/DHT/HUM", humi.."."..humi_decimal, 0, 0, function(conn) print("sent") end)
                    end
                end)
            end)
        else
            -- подключение есть и не разрывалось, ничего не делаем
        end
    else
        print("Reconnect "..wifi_status_old.." "..wifi.sta.status())
        tmr.stop(1)
        wifi.sta.connect()
    end

    -- Запоминаем состояние подключения к Wifi для следующего такта таймера
    wifi_status_old = wifi.sta.status()
end)
