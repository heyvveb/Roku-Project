sub init()
    m.productsList = m.top.findNode("productsList")
    m.loadingLabel = m.top.findNode("loadingLabel")
    m.emptyLabel = m.top.findNode("emptyLabel")
    m.top.ObserveField("visible", "OnVisibleChange")
end sub

sub OnVisibleChange()
    if m.top.visible = true
        m.productsList.SetFocus(true)
    end if
end sub

sub OnLoadingChange()
    m.loadingLabel.visible = m.top.loading
    m.productsList.visible = not m.top.loading
end sub

sub OnContentChange(event as object)
    content = event.GetData()
    m.productsList.content = content
    hasProducts = content <> invalid and content.GetChildCount() > 0
    m.emptyLabel.visible = not hasProducts
    m.productsList.visible = hasProducts
end sub
