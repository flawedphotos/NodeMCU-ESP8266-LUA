print("Starting simple web server...")

require("consts");
require("sensor_data_to_influxdb");

srv = net.createServer(net.TCP)

function receiver(conn, payload)

    local state = "CLOSED"
    local lvl = gpio.read(SENSOR_PIN)
    if lvl == SENSOR_STATUS_CODE_OPEN then
        state = "OPEN"
    end

    function send_to_influx()
        sel_do=string.sub(payload,postparse[2]+1,#payload)
        
        if sel_do == "Open" then
            sendData(TAG_VAL_DOMAIN_TEST, SENSOR_DOOR_NUMBER, SENSOR_STATUS_CODE_OPEN)
        end
        if sel_do == "Close" then
            sendData(TAG_VAL_DOMAIN_TEST, SENSOR_DOOR_NUMBER, SENSOR_STATUS_CODE_CLOSE)
        end
    end

    --parse position POST value from header
    postparse={string.find(payload,"sel_do=")}
    --If POST value exist, ...
    if postparse[2]~=nil then send_to_influx() end


       -- HTML Header Stuff
    conn:send('HTTP/1.1 200 OK\n\n')
    conn:send('<!DOCTYPE HTML>\n')
    conn:send('<html>\n')
    conn:send('<head><meta  content="text/html; charset=utf-8">\n')
    conn:send('<title>Pavel`s ESP8266 Page</title></head>\n')
    conn:send('<body><h1>Pavel`s ESP8266 Open/Close Page!</h1>\n')

    -- Labels
    conn:send('<p>State: '..state..'</p>')
    conn:send('<p>.</p>')
    conn:send('<p>DEBUG ACTIONS...</p>')

    -- Buttons 
    conn:send('<form action="" method="POST">\n')
    conn:send('<input type="submit" name="sel_do" value="Get">\n')
    conn:send('<input type="submit" name="sel_do" value="Open">\n')
    conn:send('<input type="submit" name="sel_do" value="Close">\n')
    
    conn:send('</body></html>\n')
    conn:on("sent", function(conn) conn:close() end)

    --sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n Hello, NodeMCU. ")
end

srv:listen(80, function(conn)
    conn:on("receive", receiver)
end)
