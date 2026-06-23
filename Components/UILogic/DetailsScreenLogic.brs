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
        ShowVideoScreen(content, selectedItem)
    end if
end sub

sub OnDetailsScreenVisibilityChanged(event as object)
    visible=event.getData()
    detailsScreen=event.GetRoSGNode()
    'update grid screen focus when navigate back from detailsScreen
    if visible=false
        m.GridScreen.jumpToItem=[m.selectedIndex[0],detailsScreen.itemFocused]
    end if
end sub

