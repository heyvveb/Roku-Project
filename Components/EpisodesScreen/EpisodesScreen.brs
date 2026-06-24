'Entry point of EpisodesScreen
function init()
    'Observe when episodes screen change visibility
    m.top.observeField("visible", "onVisibleChange")
    m.categoryList = m.top.findNode("categoryList")
    'Observe for which season is focus
    m.categoryList.observeField("itemFocused","OnCategoryItemFocused")
    m.itemList= m.top.findNode("itemList")
    'Observer for which episode is focus
    m.itemList.observeField("itemFocused","OnListItemFocused")
    'Observe for which episode is selected
    m.itemList.observeField("itemSelected","OnListItemSelected")
    m.top.observeField("content", "OnContentChange")
end function

sub OnListItemFocused(event as object)
    focusedItem=event.GetData()
    categoryIndex= m.itemToSection[focusedItem]
    'Change focused item in season list
    if (categoryIndex - 1) = m.categoryList.jumToItem
        m.categoryList.animateToItem = categoryIndex
    else if not m.categoryList.IsInFocusChain()
        m.categoryList.jumToItem = categoryIndex
    end if
end sub

sub InitSections(content as object)
    'Save position of the first episode for each season
    m.firstItemInSection = [0]
    'Save the season intex to which the episode belongs
    m.itemToSection = []
    'Save the title of each season
    sections = []
    sectionCount = 0
    'Goes through seasons and populate "firstItemInSection" and "itemToSection" arrays
    for each section in content.GetChildren(-1,0)
        itemsPerSection = section.GetChildrencount()
        for each child in section.GetChildren(-1,0)
            m.itemToSection.push(sectionCount)
        end for
        'Save title of each season
        sections.push({title:section.title})
        m.firstItemInSection.push(m.firstItemInSection.peek()+itemsPerSection)
        sectionCount++
    end for
    'Remove las item
    m.firstItemInSection.pop()
    'Populate categortList of seasons
    m.categoryList.content=ContentListToSimpleNode(sections)
end sub

'When season is focused
sub OnCategoryItemFocused(event as object)
    if m.categoryListGainFocues =true
        m.categoryListGainFocues = false
    else
        'index of season
        focusedItem= event.GetData()
        'navigate to the first episode of season
        m.itemList.jumToItem = m.firstItemInSection[focusedItem]
    end if
end sub

sub OnJumpToItem(event as Object)
    itemIndex = event.GetData()
    'Navigate to the specified item
    m.itemList.jumToItem=itemIndex
end sub

'When episodeScreen Content is changed
sub OnContentChange()
    content = m.top.content
    InitSections(content)
    m.itemList.content = content
end sub

'When episdoes Screen becomes visible
sub OnVisibleChange()
    if m.top.visible = true
        'Set focus to the episodes list
        m.itemList.setFocus(true)
    end if
end sub

'When a episode is selected
sub OnListItemSelected(event as object)
    'Index of selected item
    itemSelected=event.GetData()
    'Season which contains selected episode
    sectionIndex=m.itemToSection[itemSelected]
    m.top.SelectedItem=[sectionIndex, itemSelected - m.firstItemInSection[sectionIndex]]
end sub

function OnKeyEvent(key as string, press as boolean)
    result = false
    if press
        if key = "left" and m.itemList.HasFocus()
            m.categoryListGainFocues=true
            m.categoryList.setFocus(true)
            m.itemList.drawFocusFeedback= false
            result=true
        else if key = "right" and m.categoryList.HasFocus()
            m.itemList.drawFocusFeedback=true
            m.itemList.setFocus(true)
            result = true
        end if
    end if
end function