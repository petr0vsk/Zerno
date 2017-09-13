-- Credential
SSID = "petr0vsk" -- имя сетки
PASSWORD = "28Shik0mba"  -- пароль
pin = 4 -- номер ноги для блинка

--- list all visible wi-fi acces point
function listap(t)
  print("\n Visible Acces Points:")
   print("SSID   Authomode  RSSI  BSSID  Channel")
   for ssid, v in pairs(t) do 
     authomode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x;%x%x:%x%x:%x%x),(%d+)")
     print(ssid, authomode, rssi, bssid, channel)
   end
 end    
-------
