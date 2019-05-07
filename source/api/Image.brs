function ItemImages(id="" as string) as roArray
  ' This seems to cause crazy core dumps
  resp = APIRequest(Substitute("Items/{0}/Images", id))
  data = getJson(resp)
  results = []
  for each item in data
    tmp = CreateObject("roSGNode", "ImageData")
    tmp.json = item
    tmp.url = ImageURL(id, tmp.imagetype)
    results.push(tmp)
  end for
  return results
end function

string
object


function ImageURL(id as integer, 
                  version="Primary" as string, 
                  params={} as object) as string
  if params.count() = 0
    params =  {"maxHeight": "384", "maxWidth": "196", "quality": "90"}
  end if
  url = Substitute("Items/{0}/Images/{1}", id, version)
  ' ?maxHeight=384&maxWidth=256&tag=<tag>&quality=90"
  return buildURL(url, params)
end function
