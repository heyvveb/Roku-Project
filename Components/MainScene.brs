'Entry point of MainScreen
sub Init()
    'Set background color for the scene
    m.top.background = "0x32c4db"
    m.top.backgroundUri = ""
    m.loadingIndicator = m.top.FindNode("loadingIndicator")
    InitScreenStack()
    RunContentTask()
end sub