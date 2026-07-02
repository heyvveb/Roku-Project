sub ShowDetailsScreen(content as Object,selectedItem as integer)
    'Instace of details screen
    detailsScreen = CreateObject("roSGNode", "DetailsScreen")
    detailsScreen.content = content
    detailsScreen.jumpToItem = selectedItem
    detailsScreen.ObserveField("visible", "OnDetailsScreenVisibilityChanged")
    detailsScreen.ObserveField("buttonSelected", "OnButtonSelected")
    showScreen(detailsScreen)
end sub

sub OnButtonSelected(event)
    details = event.GetRoSGNode()
    content = details.content
    buttonIndex = event.getData()
    selectedItem=details.itemFocused
    'Check if "Play" button is pressed
    if buttonIndex=0
        HandlePlayButton(content, selectedItem)
    'Check if press "See all episodes"
    else if buttonIndex=1
        'Create EpisodesScreen Instance and show it
        ShowEpisodesScreen(content,selectedItem)
    end if
end sub

sub OnDetailsScreenVisibilityChanged(event as object)
    visible=event.getData()
    detailsScreen=event.GetRoSGNode()
    currentScreen = GetCurrentScreen()
    screenType = currentScreen.subType()
    if visible=false
        if screenType="GridScreen"
            'update grid screen focus when navigate back from detailsScreen
            currentScreen.jumpToRowItem=[m.selectedIndex[0],detailsScreen.itemFocused]
        else if screenType = "EpisodesScreen"
            content = detailsScreen.content.GetChild(detailsScreen.itemFocused)
            currentScreen.jumpToItem = content.numEpisodes
        end if
    end if
end sub

sub HandlePlayButton(content as object, selectedItem as integer, isResume = false as Boolean)
    itemContent = content.GetChild(selectedItem)
    'if content node is serial whit seasons
    'Set all videos in a playlist
    if itemContent.mediaType = "Group stage matches"
        children = []
        'clone all episodes of each season
        for each season in itemContent.GetChildren(-1,0)
            children.Append(CloneChildren(season))
        end for
        'Create a new node and set all episodes of serial
        node = CreateObject("roSGNode","ContentNode")
        node.id = itemContent.id
        node.Update({children: children}, true)
        index = 0
        if isResume = true
            smartBookmarks = MasterChannelSmartBookmarks()
            episodeId=smartBookmarks.GetSmartBokkmarkForSeries(itemcontent.id)
            if episodeId <> invalid and episodeId <>""
                episode = FindNodeById(content, episodeId)
                if episode <>invalid
                    index = episode.numEpisodes
                end if
            end if
        else
            episode = node.getChild(0)
            episode.bookmarkPosition = 0
        end if
        'Create a video node and star playback
        ShowVideoScreen(node,index,true)
    else
        if isResume=false
            itemContent.bookmarkPosition = 0
        end if
        ShowVideoScreen(content,selectedItem)
    end if
    if m.selectedIndex=invalid
        m.selectedIndex = [0,0]
    end if
    'Store index of selected item
    m.selectedIndex[1]=selectedItem
end sub
