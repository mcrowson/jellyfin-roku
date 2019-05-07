' Functions for making requests to the API
function buildParams(params={} as object) as string
  ' Take an object of parameters and construct the URL query 
  req = createObject("roUrlTransfer")  ' Just so we can use it for escape

  param_array = []
  for each field in params.items()
    if type(field.value) = "String" or type(field.value) = "roString"
      item = field.key + "=" + req.escape(field.value.trim())
      'item = field.key + "=" + field.value.trim()
    else if type(field.value) = "roInteger"
      item = field.key + "=" + stri(field.value).trim()
      'item = field.key + "=" + str(field.value).trim()
    else if type(field.value) = "roFloat"
      item = field.key + "=" + stri(int(field.value)).trim()
    else if type(field.value) = "roArray"
      ' TODO handle array params
    else if type(field.value) = "roBoolean"
      if field.value
        item = field.key + "=true"
      else
        item = field.key + "=false"
      end if
    else if field.value = invalid
      item = field.key + "=null"
    else if field <> invalid
      print "Unhandled param type: " + type(field.value)
      item = field.key + "=" + req.escape(field.value)
      'item = field.key + "=" + field.value
    end if
    param_array.push(item)
  end for

  return param_array.join("&")
end function

function buildURL(path as string, params={} as object) as string
  ' Creates the URL from an object of parameters
  full_url = get_base_url() + "/" + path
  if params.count() > 0
    full_url = full_url + "?" + buildParams(params)
  end if

  return full_url
end function

function APIRequest(url as string, params={} as object) as roUrlTransfer
  ' Build API request
  req = createObject("roUrlTransfer")

  if server_is_https() then
    req.setCertificatesFile("common:/certs/ca-bundle.crt")
  end if

  full_url = buildURL(url, params)

  req.setUrl(full_url)

  req = authorize_request(req)

  return req
end function

function getJson(req as object) as dynamic
  'req.retainBodyOnError(True)
  'print req.GetToString()
  data = req.GetToString()
  if data = invalid or data = ""
    return invalid
  end if
  json = ParseJson(req.GetToString())
  return json
end function

function postVoid(req as object, data="" as string) as boolean
  ' Make a POST request
  status = req.PostFromString(data)
  if status = 200
    return true
  else
    return false
  end if
end function

function postJson(req as object, data="" as string) as dynamic
  ' Returns JSON body of post request or invalid
  req.setMessagePort(CreateObject("roMessagePort"))
  req.AsyncPostFromString(data)

  resp = wait(5000, req.GetMessagePort())
  if type(resp) <> "roUrlEvent"
    return invalid
  end if

  if resp.getString() = ""
    return invalid
  end if

  json = ParseJson(resp.GetString())

  return json
end function

function get_base_url() as string
  ' Get the base URL of the Jellyfin server
  base = get_setting("server")
  port = get_setting("port")

  if base.right(1) = "/"
    base = base.left(base.len() - 1)
  end if

  if base.left(4) <> "http"
    if server_is_https()
      protocol = "https://"
    else
      protocol = "http://"
    end if
    base = protocol + base
  end if

  if port <> "" and port <> invalid then
    base = base + ":" + port
  end if

  return base
end function

function server_is_https() as boolean
  ' Returns true if server uses https protocol
  server = get_setting("server")
  port = get_setting("port")

  i = server.Instr(":")

  ' No protocol found
  if i = 0 then
    return False
  end if

  protocol = Left(server, i)
  if protocol = "https" then
    return True
  end if

  if port = "443" or port = "8920"
    return True
  end if

  return False
end function

function authorize_request(request as roUrlTransfer) as roUrlTransfer
  ' TODO - get proper version and device ID from manifest
  devinfo = CreateObject("roDeviceInfo")

  auth = "MediaBrowser"

  client = "Jellyfin Roku"
  auth = auth + " Client=" + Chr(34) + client + Chr(34)

  device = devinfo.getModelDisplayName()
  friendly = devinfo.getFriendlyName()
  auth = auth + ", Device=" + Chr(34) + device + " (" + friendly + ")" + Chr(34)

  device_id = devinfo.getChannelClientID()
  if get_setting("active_user") = invalid or get_setting("active_user") = ""
    device_id = devinfo.GetRandomUUID()
  end if
  auth = auth + ", DeviceId=" + Chr(34) + device_id + Chr(34)

  version = "10.3.0"
  auth = auth + ", Version=" + Chr(34) + version + Chr(34)

  user = get_setting("active_user")
  if user <> invalid and user <> "" then
    auth = auth + ", UserId=" + Chr(34) + user + Chr(34)
  end if

  token = get_user_setting("token")
  if token <> invalid and token <> ""
    auth = auth + ", Token=" + Chr(34) + token + Chr(34)
  end if

  request.AddHeader("X-Emby-Authorization", auth)
  return request
end function
