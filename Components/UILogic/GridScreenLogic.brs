sub ShowGridScreen()
    m.GridScreen = CreateObject("roSGNode" , "GridScreen")
    m.GridScreen.ObserveField("rowItemSelected", "OnGridScreenItemSelected")
    'show grid screen
    ShowScreen(m.GridScreen) 
end sub

sub OnGridScreenItemSelected(event as object)
    grid = event.GetRoSGNode()
    'extract the row column index of the user selected
    m.selectedIndex = event.GetData()
    'the entire row from the rowwlist will be used by the video node
    rowContent = grid.content.GetChild(m.selectedIndex[0])
    itemIndex = m.selectedIndex[1]
    ShowVideoScreen(rowContent,itemIndex)
end sub