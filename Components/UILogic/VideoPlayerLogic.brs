sub ShowVideoScreen(rowContent as Object, selectedItem=0 as Integer, isSeries = false as Boolean)
    videoScreen=CreateObject("roSGNode","VideoScreen")
    videoScreen.ObserveField("close", "OnVideoScreenClose")
    'populate video screen data
    videoScreen.isSeries = isSeries
    videoScreen.content=rowContent
    videoScreen.startIndex=selectedItem
    'append video screen to scene and show it
    ShowScreen(videoScreen)
end sub

sub OnVideoScreenClose(event as Object)
    videoScreen = event.GetRoSGNode()
    close = event.GetData()
    if close = true
        'remove video screen from scene and close it
        CloseScreen(videoScreen)
        screen = GetCurrentScreen()
        'return focus to details screen
        screen.SetFocus(true)
        if videoScreen.isSeries=false
            screen.jumpToItem = videoScreen.lastIndex
        end if
    end if
end sub
