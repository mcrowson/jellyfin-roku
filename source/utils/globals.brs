function initGlobal() as void
  ' Initializes a globals associative array to hold user data
  if m.globals = invalid
    m.globals = CreateObject("roAssociativeArray")
  end if
end function

function getGlobal(key="" as string) as dynamic
  ' Get a key stored in the global associative array
  initGlobal()
  return m.globals[key]
end function

function setGlobal(key="" as string, value=invalid as dynamic) as void
  ' Set a key/value in the global associative array
  initGlobal()
  m.globals[key] = value
end function
