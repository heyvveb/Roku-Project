'Entry point of MainScreen
sub Init()
    'Set background color for the scene
    m.top.backgroundColor = "0x171a14"
    m.top.backgroundUri = "pkg:/images/background.png"
    m.loadingIndicator = m.top.FindNode("loadingIndicator")
    m.overhang = m.top.FindNode("overhang")
    m.overhangTitle = m.top.FindNode("overhangTitle")
    InitScreenStack()
    ShowGridScreen()
    RunContentTask()
end sub