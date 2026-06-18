'Entry point of MainScreen
sub Init()
    'Set background color for the scene
    m.top.backgroundColor = "0x062593"
    m.top.backgroundUri = "pkg:/images/background.jpg"
    m.loadingIndicator = m.top.FindNode("loadingIndicator")
    InitScreenStack()
    ShowGridScreen()
    RunContentTask()
end sub