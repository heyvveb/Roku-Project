'entry point of GridScreen
sub init()
    m.rowList = m.top.FindNode("rowList")
    m.rowList.SetFocus(true)
    'label with item description
    m.descriptionLabel = m.top.FindNode("descriptionLabel")
    'observe visible field
    m.top.ObserveField("visible","OnVisibleChange")
    'label with item Tittle
    m.titleLabel = m.top.FindNode("titleLabel")
    'observe- rowItemFocused 
    m.rowList.ObserveField("rowItemFocused","OnItemFocused")
end sub

sub OnVisibleChange()
    if m.top.visible = true
        'set focus in to RowList if gridScreen is visible
        m.RowList.SetFocus(true)
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