sub ShowVideoScreen(content as Object, itemIndex as Integer, isSeries = false as Boolean)
    m.isSeries = isSeries
    'create a new instances of video node for each playback
    m.videoPlayer = CreateObject("roSGNode","Video")
    if itemIndex <> 0
        childrenClone = CloneChildren(rowContent, itemIndex)
        'Create new parent node for cloned items
        node= CreateObject("roSGNode","ContentNode")
        node.Update({children: childrenClone},true)
        m.videoPlayer.content = node
    else
        'if playblack must start from first item we clone all row node
        m.videoPlayer.content=content.Clone(true)
    end if
    'Enable video playlist
    m.videoPlayer.contentIsPlaylist= true
    'Show video screen
    ShowScreen(m.videoPlayer) 
    'Start playback
    m.videoPlayer.control = "play"
    m.videoPlayer.ObserveField("state","OnVideoPlayerStateChange")
    m.videoPlayer.ObserveField("visible", "OnVideoVisibleChange")
end sub

sub OnVideoPlayerStateChange()
    state = m.videoPlayer.state
    'close video screen in case of error or end playback
    if state="error" or state="finished"
        CloseScreen(m.videoPlayer)
    end if
end sub

sub OnVideoVisibleChange()
    if m.videoPlayer.visible=false and m.top.visible=true
        'index of video that is currently playing 
        currentIndex= m.videoPlayer.contentIndex
        'stop playback
        m.videoPlayer.control = "stop"
        m.videoPlayer.content = invalid
        m.GridScreen.SetFocus(true)
        newIndex=m.selectedIndex[1]
        if m.isSeries = true
            m.isSeries = false
        else
            newIndex += currentIndex
        end if
        'navegate to the last item played
        m.GridScreen.jumpToRowItem = newIndex
    end if
end sub
