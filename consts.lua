-- #################################
INFLUXDB_HOST = "127.0.0.1"
INFLUXDB_DB = "foobar"
-- #################################
CRLF = "\r\n"
MEASUREMENT = "DOOR_SENSOR"
TAG_KEY_SENSOR = "DOOR_NUM"
TAG_KEY_DOMAIN = "DOMAIN"
-- the following should be used by the caller of methods defined here
TAG_VAL_DOMAIN_PROD = "PROD"
TAG_VAL_DOMAIN_TEST = "TEST"
TAG_VAL_DOMAIN_PROD = "PROD"

SENSOR_STATUS_CODE_CLOSE = 0
SENSOR_STATUS_CODE_OPEN = 1

SENSOR_TIMER_FIRE_MS = 60*1000

-- door number 0 used for testing
SENSOR_DOOR_NUMBER = "1"
-- There is a mapping to GPIO index but I can't figure it out so
-- pin number seems to correspond to D[num]. Whatever...
SENSOR_PIN = 1
