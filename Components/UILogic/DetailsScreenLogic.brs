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

sub HandlePlayButton(content as object, selectedItem as integer)
    itemContent = content.GetChild(selectedItem)
    'if content node is serial whit seasons
    'Set all videos in a playlist
    if itemContent.mediaType = "series"
        children = []
        'clone all episodes of each season
        for each season in itemContent.GetChildren(-1,0)
            children.Append(CloneChildren(season))
        end for
        'Create a new node and set all episodes of serial
        node = CreateObject("roSGNode","ContentNode")
        node.Update({children: children}, true)
        'Create a video node and star playback
        ShowVideoScreen(node,0,true)
    else
        ShowVideoScreen(content,selectedItem)
    end if
    'Store index of selected item
    m.selectedIndex[1]=selectedItem
end sub
