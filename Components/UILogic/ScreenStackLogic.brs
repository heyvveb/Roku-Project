sub InitScreenStack()
    m.screenStack = []
end sub

sub ShowScreen(node as Object)
    'Take current screen from screen stack
    prev = m.screenStack.Peek()
    if prev <> invalid
        'Hide the current screen if exist
        prev.visible= false
    end if
    'Show new screen
    m.top.AppendChild(node)
    node.visible=true
    node.SetFocus(true)
    'add new screen to the screen stack
    m.screenStack.Push(node)
end sub

sub CloseScreen(node as Object)
    if node = invalid OR id (m.screenStack.Peek() <> invalid and m.screenStack.Peek().IsSameNode(node))
        'remove screen from screen stack
        last= m.screenStack.Pop()
        'hide screen
        last.visible=false
        'Remove screen from scene
        m.top.RemoveChild(node)
        'take previous screen and make it visible
        prev = m.screenStack.Peek()
        if prev <> invalid
            prev.visible = true
            prev.SetFocus(true)
        end if
    end if
end sub