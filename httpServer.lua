do
    local M = {};
    M.getListeners = {};
    M.postListeners = {};

    function M.startServer(port)
        http = net.createServer(net.TCP);
        http:listen(port , function(conn)
            conn:on("receive", M.receive_http)
        end);
        print("Server started on "..port.." port");
    end;

    function M.receive_http(sck, data)
        local method = string.match(data, "^[A-Za-z]+");
        local path = string.match(data, "/[^ ?]*");
        print("method: "..method);
        print("path: "..path);

        if method == "GET" then
            if M.getListeners[path] ~= nil then
                local res = M.getListeners[path]();
                local response = "HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n";

                if res ~= nil then response = response..res end;
                
                sck:send(response);
                sck:on("sent", function(sck) sck:close() end);
                return true;
            end;
        end;

        if method == "POST" then
            if M.postListeners[path] ~= nil then
                local res = M.postListeners[path]();
                local response = "HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n";
                if res ~= nil then response = response..res end;
                sck:send(response);
                sck:on("sent", function(sck) sck:close() end);
                return true;
            end;
        end;

        sck:on("sent", function(sck) sck:close() end);

        local response = "HTTP/1.0 404 Not Found\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\nPage "..path.." is not found!";
        sck:send(response);
        return false;
    end;
        
    

    function M.get(addr, callback)
        M.getListeners[addr] = callback;
    end;

    function M.post(addr, callback)
        M.postListeners[addr] = callback;
    end;
    
    return M
end
