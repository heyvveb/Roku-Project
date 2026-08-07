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
end function

sub OnVisibleChange()
    'Set focus for buttons list when DetailsScreen become visible
    if m.top.visible = true
        m.buttons.SetFocus(true)
    end if
end sub

sub SetButtons(buttons as object)
    'Create buttons
    result = []
    for each button in buttons
        result.Push({title: button, id: LCase(button)})
    end for
    'Set list of buttons for detailsScreen
    m.buttons.content = ContentListToSimpleNode(result)
end sub

sub OnContentChange(event as object)
    content = event.getData()
    if content <> invalid
        m.isContentList=content.GetChildCount()>0
        if m.isContentList=false
            SetDetailsContent(content)
            m.buttons.SetFocus(true)
        end if
    end if
end sub

sub SetDetailsContent(content as object)
    m.poster.uri = content.hdPosterURL
    m.description.text = content.description
    if content.length <> invalid and content.length <> 0
        m.timeLabel.text = GetTime(content.length)
    end if
    m.titleLabel.text = content.title
    m.releaseLabel.text = Left(content.releaseDate,10)
    buttonList = ["Play"]
    if content.mediaType = "Group stage matches"
        smartBookmarks=MasterChannelSmartBookmarks()
        'id of episode which should be played
        episodeId=smartBookmarks.GetSmartBookmarkforSeries(content.id)
        if episodeId <> invalid and episodeId <> ""
            episode = FindNodeById(content,episodeId)
            if episode <> invalid
                episode.bookmarkPosition = MasterChannelBookmarks().GetBookmarkForVideo(episode)
                buttonList.Push("Continue")
            end if
        end if
        buttonList.Push("See all episodes")
    else
        'set playback start position using bookmarks
        content.bookmarkPosition = MasterChannelBookmarks().GetBookmarkForVideo(content)
        'add continue button if user started this content but didnt finish it
        if content.bookmarkPosition > 0
            buttonList.Push("Continue")
        end if
    end if
    SetButtons(buttonList)
end sub

sub OnJumpToItem()
    content = m.top.content
    if content <> invalid and m.top.jumpToItem >= 0 and content.GetChildCount() > m.top.jumpToItem
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub

sub OnItemFocusedChanged(event as Object)
    focusedItem= event.GetData()
    if m.top.content.GetChildCount() > 0
        content = m.top.content.GetChild(focusedItem)
        SetDetailsContent(content)
    end if
end sub

function OnKeyEvent(key as string, press as Boolean) as Boolean
    result= false
    if press
        'Position of the currently focused item
        currentItem = m.top.itemFocused
        if key ="left" and m.isContentList = true
            m.top.jumpToItem = currentItem - 1
            result=true
        else if key="right" and m.isContentList = true
            m.top.jumpToItem = currentItem + 1
            result=true
        end if
    end if
    return result
end function