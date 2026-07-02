function GetSupportedMediaTypes() as Object
    return{
        "series": "series"
        "season": "season"
        "episode": "episode"
        "movie": "movies"
        "shortFormVideo": "shortFormVideos"
    }
end function

'When roInputEvent occurred
sub OnInputDeepLinking(event as object)
    args=event.getData()
    'Validate deep link arguments
    if args <> invalid and ValidateDeepLink(args)
        'Perfom deep linking
        DeepLink(m.GridScreen.content, args.mediaType, args.contentId)
    end if
end sub

'Check if deep link arguments are valid
function ValidateDeepLink(args as Object) as Boolean
    mediaType = args.mediaType
    contentId= args.contentId
    types = GetSupportedMediaTypes()
    return mediaType <> invalid and contentId <> invalid and types[mediaType] <> invalid
end function

'perfom deep linking
sub DeepLink(content as object, mediaType as String, contentId as String)
    'find content for deep linking by content id
    playableItem = FindNodeById(Content, contentId)
    types = GetSupportedMediaTypes()
    'check if chose item has appropiate mediaType
    if playableItem <> invalid and playableItem.mediaType = types[mediaType]
        'Remove all scren from screen stack exept grid screen
        ClearScreenStack()
        'looking for appropriate handler for provided mediatype
        if mediaType = "episode" or mediaType="shorFormVideo" or mediaType="movie"
            HandlePlayableMediaTypes(playableItem)
        else if mediaType = "season"
            HandleSeasonMediaType(playableItem)
        else if mediaType = "series"
            HandleSeriesMediaType(playableItem)
        end if
    end if
end sub

'Handle for season type
sub HandleSeasonMediaType(content as object)
    'Number of chosen episode
    itemIndex = content.numEpisodes
    'Series node of the episode mapped to the content id
    series = content.getParent().getParent()
    'launch episodes screen
    episodes = ShowEpisodesScreen(series, itemIndex)
    episodes.ObserveField("visible","OnDeepLinkDetailsScreenVisibilityChanged")
end sub

'Handle for Episode, shorfromvideo and movie types
sub HandlePlayableMediaTypes(content as Object)
    'Create details Screen and push it to the screen stack
    PrepareDetailsScreen(content)
    ShowVideoScreen(content)
end sub

'Handler for series type
sub HandleSeriesMediaType(content as object)
    children = []
    'clone all episodes of each season
    for each season in content.getChildren(-1,0)
        children.Append(CloneChildren(season))
    end for
    'Create a new node and set episodes of serial
    node = CreateObject("roSGNode","ContentNode")
    node.id=content.id
    node.Update({children:children},true)
    smartBookmarks=MasterChannelSmartBookmarks()
    'id of the episode which should be played
    episodeId= smartBookmarks.GetSmartBookmarkForSeries(content.id)
    ' if episode is invalid launch fir episode of series
    index = 0
    if episodeId <> invalid and episodeId<> ""
        'find episode by id
        episode = FindNodeById(content,episodeId)
        if episode <> invalid
            'number of chosen episode
            index = episode.numEpisodes
        end if
    end if
    'Create details screen and push it to the screen
    PrepareDetailsScreen(node.getChild(index))
    ShowVideoScreen(node,index,true)
end sub

sub prepareDetailsScreen(content as object)
    'Create Details Screen to be shown when user navigate from video player
    'it will contain info about played content
    m.deepLinkDetailsScreen=CreateObject("roSGNode","DetailsScren")
    m.deepLinkDetailsScreen.content = content
    m.deepLinkDetailsScreen.ObserveField("visible", "OnDeepLinkDetailsScreenVisibilityChanged")
    m.deepLinkDetailsScreen.ObserveField("buttonSelected", "OnDeepLinkDetailsScreenButtonSelected")
    AddScreen(m.deepLinkDetailsScreen)
end sub

'When details screen or episodes screen change visibility
sub OnDeepLinkDetailsScreenVisibilityChanged(event as object)
    visible = event.getData()
    screen = event.GetRoSGNode()
    if visible = false and IsScreenInScreenStack(screen) = false
        content = screen.content
        if content <> invalid
            'jump to appropiate title on grid screen
            m.GridScreen.jumpToRowItem = [content.homeRowindex, content.homeItemIndex]
            'Invalidate deeplink details screen if user press "back" button
            if m.deepLinkDetailsScreen <> invalid
                m.deepLinkDetailsScreen = invalid
            end if
        end if
    end if
end sub

'When button is presed on details screen
sub OnDeepLinkDetailsScreenButtonSelected(event as object)
    'Index of selected button
    buttonIndex = event.GetData()
    details = event.GetRoSGNode()
    button = details.buttons.getChild(buttonIndex)
    content = m.deepLinkDetailsScreen.content.clone(true)
    'Start playback from the beginning if user select play button
    if button.id = "play"
        content.bookmarkPosition = 0
    end if
    ShowVideoScreen(content)
end sub