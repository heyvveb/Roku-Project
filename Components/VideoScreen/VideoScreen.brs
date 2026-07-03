function Init()
    'Rectangle Fields
    m.top.width=1280
    m.top.height = 720
    m.top.color = "0x000000"
    'Store reference for player task
    m.playerTask= m.top.findNode("PlayerTask")
    'Close screen once exited
    m.playerTask.ObserveField("state", "OnPlayerTaskStateChange")
    m.top.ObserveField("visible","OnVisibleChanged")
end function

sub OnVisibleChanged(event as object)
    visible = event.GetData()
    'Video node content must be invalidated if video screen is closed but player task still running
    if visible = false and m.playerTask <> invalid
        m.playerTask.UnObserveField("state")
        m.playerTask.control = "STOP"
        'Get video node wrapper created by RAF
        RAFRenderer = m.top.Getchild(m.top.GetchildCount()-1)
        if RafRenderer  <> invalid
            'Get video node
            video = RafRenderer.getChild(0)
            if video <> invalid and LCase(video.id) = "contentvideo"
                video.content = invalid
                RAFRenderer = invalid
            end if
        end if
        m.playerTask = invalid
    end if
end sub
sub OnIndexChanged(event as object)
    content = m.top.content
    index = event.GetData()
    'check if content was populated
    if content <> invalid
        'set playlist data and start task
        m.playerTask.content = content
        m.playerTask.startIndex = index
        m.playerTask.isSeries = m.top.isSeries
        m.playerTask.control = "RUN"
    end if
end sub

'close video screen once playertask finished or stopped
sub OnPlayerTaskStateChange(event as object)
    state = event.GetData()
    if state = "done" or state = "stop" and m.playerTask <> invalid
        m.playerTask = invalid
        m.top.close =true
    end if
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        'handle "back" key press
        if key="back" and m.playerTask <> invalid
            'Stop playback and close this screen
            m.playerTask.control = "STOP"
            result = true
        end if
    end if
    return result
end function
