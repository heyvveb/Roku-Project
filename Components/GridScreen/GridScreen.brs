'entry point of GridScreen
sub init()
    m.rowList = m.top.FindNode("rowList")
    m.rowList.SetFocus(true)
    'label with item description
    m.descriptionLabel = m.top.FindNode("descriptionLabel")
    'label with item Tittle
    m.tittleLabel = m.top.FindNode("tittleLabel")
    'observe- rowItemFocused 
    m.rowList.ObserveField("rowItemFocused","OnItemFocused")
end sub

sub OnItemFocused()
    'get the position of focused item in the row
    focusedIndex = m.rowList.rowItemFocused
    'get all items of the row
    Row = m.rowList.content.Getchild(focusedIndex[0])
    'get focused item
    item = row.Getchild(focusedIndex[1])
    'update description label with the descrition of focused item
    m.descriptionLabel.text = item.description
    'update tittle label with de tittle of focused item
    m.descriptionLabel.text = item.description
    'adding lenght of playback to the title
    if item.length <> invalid
        m.tittleLabel.text += " | " + GetTime(item.length)
    end if
end sub

function GetTime(length as Integer) as string
    minutes = ( length / 60).ToStr()
    seconds=lenght MOD 60 
    if seconds < 60
        seconds = "0" + seconds.ToStr()
    else
        seconds = seconds.ToStr()
    end if
    return minutes + " : " + seconds
end function