function Init()
    'Rectangle Fields
    m.top.width=1280
    m.top.height = 720
    m.top.color = "0x000000"
    'Store reference for player task
    m.playerTask= m.top.findNode("PlayerTask")
    'Close screen once exited
    m.playerTask.ObserveField("state", "OnPlayerTaskStateChange")
end function

sub OnIndexChanged(event as object)
    content = m.top.content
    index = event.GetData()
    'check if content was populated
    if content <> invalid
        'set playlist data and start task
        m.playerTask.content = content
        m.playerTask.startIndex = index
        m.playerTask.control = "RUN"
    end if
end sub

'close video screen once playertask finished or stopped
sub OnPlayerTaskStateChange(event as object)
    state = event.GetData()
    if state = "done" or state = "stop"
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
