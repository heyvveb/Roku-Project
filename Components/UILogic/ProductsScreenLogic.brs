'Create the products screen, push it to the screen stack and kick off the catalog request
sub ShowProductsScreen()
    m.productsScreen = CreateObject("roSGNode", "ProductsScreen")
    m.productsScreen.loading = true
    ShowScreen(m.productsScreen)
    RunChannelStoreTask()
end sub

'Create the ChannelStoreTask, observe its catalog field, and run it
sub RunChannelStoreTask()
    m.channelStoreTask = CreateObject("roSGNode", "ChannelStoreTask")
    m.channelStoreTask.ObserveField("catalog", "OnCatalogLoaded")
    m.channelStoreTask.ObserveField("catalogError", "OnCatalogError")
    m.channelStoreTask.control = "RUN"
end sub

'When the content node of the catalog is filled
sub OnCatalogLoaded(event as object)
    catalog = event.GetData()
    m.productsScreen.loading = false
    m.productsScreen.content = catalog
end sub

'When the loading cataloge failed
sub OnCatalogError(event as object)
    m.productsScreen.loading = false
    print "ChannelStoreTask error: "; event.GetData()
end sub

