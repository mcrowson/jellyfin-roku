' "Registry" is where Roku stores config


' Generic registry accessors
function registry_read(key as string, section=invalid) as dynamic
  ' Reads a registry value, returns invalid if it does not exist
  if section = invalid then return invalid
  reg = CreateObject("roRegistrySection", section)
  if reg.exists(key) then return reg.read(key)
  return invalid
end function

function registry_write(key as string, value as dynamic, section=invalid) as dynamic
  ' Writes a value to the registry, returns invalid if no section is given
  if section = invalid then return invalid
  reg = CreateObject("roRegistrySection", section)
  reg.write(key, value)
  reg.flush()
end function

function registry_delete(key as string, section=invalid) as dynamic
  ' Removes a value from the registry, returns invalid if no section is given
  if section = invalid then return invalid
  reg = CreateObject("roRegistrySection", section)
  reg.delete(key)
  reg.flush()
end function


' "Jellyfin" registry accessors for the default global settings
function get_setting(key as string, default=invalid) as dynamic
  ' Reads registry for Jellyfin section
  value = registry_read(key, "Jellyfin")
  if value = invalid return default
  return value
end function

function set_setting(key as string, value as dynamic) as dynamic
  ' Writes to registry for Jellyfin section
  registry_write(key, value, "Jellyfin")
end function

function unset_setting(key as string) as void
  ' Removes a registry value for Jellyfin section
  registry_delete(key, "Jellyfin")
end function


' User registry accessors for the currently active user
function get_user_setting(key as string, default=invalid) as dynamic
  ' Get the user settings saved in registry
  if get_setting("active_user") = invalid then return default
  value = registry_read(key, get_setting("active_user"))
  if value = invalid return default
  return value
end function

function set_user_setting(key as string, value as dynamic) as dynamic
  ' Sets the user settings in the registry. Returns invalid if the key does not exist
  if get_setting("active_user") = invalid then return invalid
  registry_write(key, value, get_setting("active_user"))
end function

function unset_user_setting(key as string) as dynamic
  ' Unsets the user settings in the registry
  if get_setting("active_user") = invalid then return invalid
  registry_delete(key, get_setting("active_user"))
end function
