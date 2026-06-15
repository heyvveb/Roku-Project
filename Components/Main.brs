'Channel entry point
sub Main()
    ShowChannelRSGScreen()
end sub

sub ShowChannelRSGScreen()
    'Create object roSGScreen
    screen = CreateObject("roSGScreen")
    'Message port when an event is sent
    m.port = CreateObject("roMessagePort")
    'Set message port used for event
    screen.SetMessagePort(m.port)
    'Every screen object have a scene node, 
    scene = screen.CreateScene("MainScene")
    'Init method in MainScene.brs 
    screen.Show()
    
    'event loop
    while(true)
        'waiting for events screen
        msg= wait(0,m.port)
        msgType= type(msg)
        if msgType= "roSGScreenEvent"
            if msg.IsScreenClosed() then return
        end if
    end while
end sub