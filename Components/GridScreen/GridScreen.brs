'entry point of GridScreen
sub init()
    m.rowList = m.top.FindNode("rowList")
    m.buttons = m.top.findNode("buttons")
    'label with item description
    m.descriptionLabel = m.top.FindNode("descriptionLabel")
    'observe visible field
    m.top.ObserveField("visible","OnVisibleChange")
    'label with item Tittle
    m.titleLabel = m.top.FindNode("titleLabel")
    'observe- rowItemFocused
    m.rowList.ObserveField("rowItemFocused","OnItemFocused")
    SetButtons()
end sub

sub OnVisibleChange()
    if m.top.visible = true
        'set focus in to buttons if gridScreen is visible
        m.buttons.SetFocus(true)
    end if
end sub

sub OnItemFocused()
    'get the position of focused item in the row
    focusedIndex = m.rowList.rowItemFocused
    'get all items of the row
    row = m.rowList.content.Getchild(focusedIndex[0])
    'get focused item
    item = row.Getchild(focusedIndex[1])
    'update description label with the descrition of focused item
    m.descriptionLabel.text = item.description
    'update tittle label with de tittle of focused item
    m.titleLabel.text = item.title
    'adding lenght of playback to the title
    if item.length <> invalid and item.length<>0
        m.titleLabel.text += " | " + GetTime(item.length)
    end if
end sub

sub SetButtons()
    'Create buttons
    buttons = ["Products"]
    result = []
    for each button in buttons
        result.Push({title: button, id: LCase(button)})
    end for
    'Set list of buttons for GridScreen
    m.buttons.content = ContentListToSimpleNode(result)
    m.buttons.SetFocus(true)
end sub

'Change of focus between rowlist and buttons
function OnKeyEvent(key as String, press as Boolean) as Boolean
    result= false
    if press
        if key ="down" and m.buttons.isInFocusChain()
            m.rowList.setFocus(true)
            result = true
        else if key ="up" and m.rowList.isInFocusChain()
            m.buttons.setFocus(true)
            m.descriptionLabel.text = ""
            m.titleLabel.text = ""
            result = true
        end if
    end if
    return result
end function