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
    if node = invalid OR (m.screenStack.Peek() <> invalid and m.screenStack.Peek().IsSameNode(node))
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

sub AddScreen(node as object)
    m.top.AppendChild(node)
    m.screenStack.Push(node)
end sub

sub ClearScreenStack()
    if m.screenStack.count()>1
        while m.screenStack.count()>1
            'Reomve screen from screen stack
            last = m.screenStack.Pop()
            if last.visible = true
                'Hide Screen
                last.visible = false
            end if
            m.top.RemoveChild(last)
        end while
    else
        'take current screen from screen stack
        m.screenStack.peek().visible = false
    end if
end sub

function GetCurrentScreen()
    return m.screenStack.Peek()
end function

function IsScreenInScreenStack(node as object) as Boolean
    'check if screen stack contains specified node
    for each screen in m.screenStack
        result = screen.IsSameNode(node)
        if result = true
            return true
        end if
    end for
    return false
end function