' entry endpoint of detailScreen
function init()
    'observe "visible" to know when DetailScreen change visibility
    m.top.observeField("visible", "OnVisibleChange")
    'To know when another item gets in focus
    m.top.observeField("itemFocused", "OnItemFocusedChanged")
    'save references to the DetailsScreen child components in the m variable
    m.buttons = m.top.findNode("buttons")
    m.poster = m.top.findNode("poster")
    m.description = m.top.findNode("descriptionLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.titleLabel = m.top.findNode("titleLabel")
    m.releaseLabel = m.top.findNode("releaseLabel")
    'Create buttons
    result = []
    for each button in ["PLay"]
        result.Push({title: button})
    end for
    'Set list of buttons for detailsScreen
    m.buttons.content = ContentListToSimpleNode(result)
end function

sub OnVisibleChange()
    'Set focus for buttons list when DetailsScreen become visible
    if m.top.visible = true
        m.buttons.SetFocus(true)
        m.top.itemFocused =  m.top.jumpToItem
    end if
end sub

sub SetDetailsContent(content as Object)
    m.poster.uri = content.hdPosterURL
    m.description.text = content.description
    m.timeLabel = GetTime(content.length)
    m.titleLabel = content.title
    m.releaseLabel = content.releaseDate
end sub

sub OnJumpToItem()
    content = m.top.content
    if content <> invalid and m.top.jumpToItem >= 0 and content.GetChildCount() > m.top.jumpToItem
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub

sub OnItemFocusedChanged(event as Object)
    focusedItem= event.GetData()
    content = m.top.content.GetChild(focusedItem)
    SetDetailsContent(content)
end sub

function OnKeyEvent(key as string, press as Boolean) as Boolean
    result= false
    if press
        'Position of the currently focused item
        currentItem = m.top.itemFocused
        if key ="left"
            m.top.jumpToItem = currentItem - 1
            result=true
        else if key="right"
            m.top.jumpToItem = currentItem + 1
            result=true
        end if
    end if
    return result
end function