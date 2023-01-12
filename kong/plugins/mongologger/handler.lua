local kong_meta = require "kong.meta"

local mongo = require 'mongo'

local kong = kong

local plugin = {
  PRIORITY = 9,
  VERSION = kong_meta.version,
}

-- handles more initialization, but AFTER the worker process has been forked/created.
-- It runs in the 'init_worker_by_lua_block'
function plugin:init_worker()

  -- your custom code here
  kong.log.debug("saying hi from the 'init_worker' handler")

end --]]

local function log()
  kong.log("access function invoked")
  local client = mongo.Client('mongodb://mongo:27017')
  local collection = client:getCollection('WhatsAppMessaging', 'ApiRequest')
  local req_body, err, mimetype = kong.request.get_body()
  local raw_req_body  = kong.request.get_raw_body()
  local response_body = '' --kong.response.get_raw_body();
  --if ( kong.response ~= nil and kong.response.get_raw_body()~=nil ) then
  --  response_body = kong.response.get_raw_body()
  --end
  --kong.log(">>>>>>>>>>>>>> received body: ", req_body)
  --kong.log(">>>>>>>>>>>>>> received body: ", response_body)

  if (req_body == nil) then
          return
  end

  local id = mongo.ObjectID()
  --collection:insert{_id = id, logDate = os.date("%d-%m-%Y %H:%M:%S"), apiName ='sendmessage',recipientNumber=req_body.to,clientIpAddress='',upstreamUri='',requestBody=raw_req_body,responseBody=response_body,validWhatsAppNumber='true',contact_WaId=req_body.to,result='true',templateName=req_body.template.name}
  collection:insert{body=raw_req_body,logDate = os.date("%d-%m-%Y %H:%M:%S"), apiName ='sendmessage'}
end

-- runs in the 'access_by_lua_block'
function plugin:access(plugin_conf)
  log()
  --kong.log.inspect(plugin_conf)   -- check the logs for a pretty-printed config!
  --kong.service.request.set_header(plugin_conf.request_header, "this is on a request")
end --]]


function plugin:log(conf)
end

return plugin