wifiHelper = require('wifiHelper');
httpServer = require("httpServer");

local ssid = ""; -- Your wifi ssid
local pass = ""; -- Your wifi pass

wifiHelper.connect(ssid, pass);

local resp = ""..
    "<html>".. 
        "<head>"..
            "<meta charset='utf-8' />"..
            "<title>Main page</title>"..
        "</head>"..
        "<body>"..
            "<a href='on'><button>Turn on</button></a>"..
            "<a href='off'><button>Turn off</button></a>"..
        "</body>"..
    "</html>";

gpio.mode(4, gpio.OUTPUT);

-- default off
gpio.write(4, gpio.HIGH);

httpServer.get('/', function() 
    return resp;
end);

httpServer.get('/on', function() 
    gpio.write(4, gpio.LOW);
    return resp;
end);

httpServer.get('/off', function() 
    gpio.write(4, gpio.HIGH);
    return resp;
end);

httpServer.startServer(80);

print("Main started");




    
