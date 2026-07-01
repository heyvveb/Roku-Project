'Channel entry point
sub Main(args as object)
    ShowChannelRSGScreen(args)
end sub

sub ShowChannelRSGScreen(args as Object)
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
    scene.launchArgs= args
    inputObject = CreateObject("roInput")
    inputObject.SetMessagePort(m.port)
    'event loop
    while(true)
        'waiting for events screen
        msg= wait(0,m.port)
        msgType= type(msg)
        ? "msgTyp=" msgType
        if msgType= "roSGScreenEvent"
            if msg.IsScreenClosed() then return
        else if msgType="roInputEvent"
            inputData = msg.getInfo()
            ? "input"
            'Pass the deeplink to UI
            if inputData.DoesExist("mediType") and inputData.DoesExist("contentId")
                deeplink = {
                    contentId: inputData.contentId
                    mediaType: inputData.mediaType
                }
                scene.inputArgs = deeplink
            end if
        end if
    end while
end sub