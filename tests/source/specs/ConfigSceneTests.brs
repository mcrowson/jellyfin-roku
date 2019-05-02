'@SGScreen ConfigSceneTests
'@TestSuite [CFT] Config Scene Tests

'@Setup
function CFT_setup() as void
    m.setupThing = "something created during setup"
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests methods present on the node
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@BeforeEach
function CFT_BeforeEach() as void
    m.beforeEachThing = "something created beforeEach"
end function

'@Test HelloFromNode
function CFT_HelloFromNode_simple() as void
    m.AssertTrue(True)
end function
