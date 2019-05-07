function MarkItemFavorite(id as string) as object
  ' POST to Jellyfin server marking an item as favorite
  url = Substitute("Users/{0}/FavoriteItems/{1}", get_setting("active_user"), id)
  resp = APIRequest(url)
  return postJson(resp)
end function

function UnmarkItemFavorite(id as string) as object
  ' POST to Jellyfin server marking an item as unfavorite
  url = Substitute("Users/{0}/FavoriteItems/{1}", get_setting("active_user"), id)
  resp = APIRequest(url)
  resp.setRequest("DELETE")
  return getJson(resp)
end function

function MarkItemWatched(id as string) as void
  ' POST to Jellyfin server marking an item as watched
  date = CreateObject("roDateTime")
  date.toLocalTime()
  dateStr = stri(date.getYear()).trim()
  dateStr += leftPad(stri(date.getMonth()).trim(), "0", 2)
  dateStr += leftPad(stri(date.getDayOfMonth()).trim(), "0", 2)
  dateStr += leftPad(stri(date.getHours()).trim(), "0", 2)
  dateStr += leftPad(stri(date.getMinutes()).trim(), "0", 2)
  dateStr += leftPad(stri(date.getSeconds()).trim(), "0", 2)

  url = Substitute("Users/{0}/PlayedItems/{1}", get_setting("active_user"), id)
  resp = APIRequest(url, {"DatePlayed": dateStr})
  data = postJson(resp)
end function

function UnmarkItemWatched(id as string) as object
  ' POST to Jellyfin server marking item as unwatched
  url = Substitute("Users/{0}/PlayedItems/{1}", get_setting("active_user"), id)
  resp = APIRequest(url)
  resp.setRequest("DELETE")
  return getJson(resp)
end function
