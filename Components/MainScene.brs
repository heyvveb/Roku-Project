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

'Funtion that recibes events of remote control
function OnKeyEvent(key as String, press as Boolean) as boolean
    result= false
    if press
        'Back key press
        if key = "back"
            numberOfScreens=m.screenStack.Count()
            'Close top screen if there are two or more screen in the stack
            if numberOfScreens>1
                CloseScreen(invalid)
                result=true
            end if
        end if
    end if
    'Return true if component handled the event
    return result
end function