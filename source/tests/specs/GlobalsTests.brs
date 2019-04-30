'@TestSuite [GLT] GlobalsTests

'@BeforeEach
function GLT_BeforeEach()
  initGlobal()
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests constructor
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test constructor of global
function GLT__constructor_basic() as void
    m.AssertEqual(m.globals, CreateObject("roAssociativeArray"))
end function


'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests set globals
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test basic set test
'@Params["k", "v"]
'@Params[2, "v"]
'@Params["K", 2]
function GLT__setGlobals(key, value) as void
    setGlobals(key, value)
    m.AssertEqual(v, m.globals[key])
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests get globals
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test basic test
'@Params["mp4", ["a", "b", "c"]]
'@Params["mp3", ["a", "b", "c", "d", "e"]]
function GLT_getGlobals(key, value) as void
  m.globals[key] = value
  m.AssertEqual(getGlobals(key), value)
end function