sub ShowGridScreen()
    m.GridScreen = CreateObject("roSGNode" , "GridScreen")
    m.GridScreen.ObserveField("rowItemSelected", "OnGridScreenItemSelected")
    m.GridScreen.ObserveField("buttonSelected", "OnButtonGridSelected")
    'show grid screen
    ShowScreen(m.GridScreen) 
end sub

sub OnGridScreenItemSelected(event as object)
    grid = event.GetRoSGNode()
    'extract the row column index of the user selected
    m.selectedIndex = event.GetData()
    'the entire row from the rowwlist will be used by the video node
    rowContent = grid.content.GetChild(m.selectedIndex[0])
    m.selectedRow = m.selectedIndex[0]
    ShowDetailsScreen(rowContent,m.selectedIndex[1])
end sub

sub OnButtonGridSelected(event)
    details = event.GetRoSGNode()
    content = details.content
    buttonIndex = event.getData()
    button = details.buttons.getChild(buttonIndex)
    selectedItem=details.itemFocused
    'Check if "Products" button is pressed
    if button.id = "products"
        ShowProductsScreen()
    end if
end sub