-- ###### InfluxDB Structure ######
--
-- Measurement is like a table name
-- Field key is SensorData
-- Field value is 0 for closed, 1 for open
-- Tags keys are: SensorId, DOMAIN
-- Tag values, ex 1: Door1, Test
-- Tag values, ex 2: Door2, Prod
--
-- Ex: http://localhost:8086/write?db=mydb --data-binary 'measurement,tag_key_1=tag_val_1,tag_key_2=tag_val_2 value=field_val timestamp'
--
-- #################################

require("consts");

function getContent(domain, door_num, sensor_val)
  local result = MEASUREMENT..
    ","..TAG_KEY_SENSOR.."="..door_num..
	","..TAG_KEY_DOMAIN.."="..domain..
    " value="..sensor_val

  return result
end

function buildPostRequest(host, db, data)
  return "POST /write?db="..db.." HTTP/1.1"..CRLF..
    "Host: "..host..CRLF..
    "Connection: close"..CRLF..
    "Content-Type: application/x-www-form-urlencoded"..CRLF..
    "Content-Length: "..string.len(data)..CRLF..
    CRLF..
    data
end

function sendData(domain, door_num, sensor_status_code)
  print("sendig data... inputs are..."..
    "domain: "..domain..
    "; door_num: "..door_num..
    "; sensor_status_code: "..sensor_status_code)
  
  local content = getContent(domain, door_num, sensor_status_code)

  print("Sending data to InfluxDb...")

  socket = net.createConnection(net.TCP, 0)
  socket:on("receive",function(sck, c) print(c) end)
  socket:connect(8086, INFLUXDB_HOST)
  socket:on("connection", function(sck)
    local post_request = buildPostRequest(INFLUXDB_HOST, INFLUXDB_DB, content)
    sck:send(post_request)
  end)
  print("Sent data to InfluxDb.")
end
