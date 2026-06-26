sub ShowEpisodesScreen(content as object, selectedItem as Integer)
    'Create instance of the episodes screen
    episodesScreen = CreateObject("roSGNode","EpisodesScreen")
    'Observe for know which episode is selected
    episodesScreen.ObserveField("selectedItem", "OnEpisodesScreenItemSelected")
    'Populate episodesScreen whit content based on which serial was chosen
    episodesScreen.content=content.GetChild(selectedItem)
    ShowScreen(episodesScreen)
end sub


sub OnEpisodesScreenItemSelected(event as object)
    episodesScreen = event.GetRoSGNode()
    'extract the row and column indexes of the item the user selected
    selectedIndex = event.GetData()
    'The row from episodes screen will be used by the detailsScreen
    rowContent=episodesScreen.content.GetChild(selectedIndex[0])
    ShowDetailsScreen(rowContent, selectedIndex[1])
end sub