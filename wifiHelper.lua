-- connect to WiFi helper module
do
    local M = {};
    
    function M.connect(login, password)
        wifi.setmode(wifi.STATION);    
        local config = {};
            config.ssid = login;
            config.pwd = password;
        wifi.sta.config(config);
    end;

    return M;
end


