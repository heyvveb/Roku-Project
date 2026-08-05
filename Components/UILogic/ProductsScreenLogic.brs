'Create the products screen, push it to the screen stack and kick off the catalog request
sub ShowProductsScreen()
    m.productsScreen = CreateObject("roSGNode", "ProductsScreen")
    m.productsScreen.loading = true
    m.productsScreen.ObserveField("productSelected","OnProductSelected")
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

sub OnProductSelected(event as object)
    index = event.GetData()
    product = m.productsScreen.content.GetChild(index)
    if product.isEntitled = true
        return
    end if
    m.productsScreen.loading=true
    m.purchaseTask = CreateObject("roSGNode","PurchaseTask")
    m.purchaseTask.productCode=product.id
    m.purchaseTask.ObserveField("purchaseSucceeded", "OnPurchaseSucceeded")
    m.purchaseTask.ObserveField("purchaseError", "OnPurchaseError")
    m.purchaseTask.control="RUN"
end sub

sub OnPurchaseSucceeded(event as object)
    succeeded=event.GetData()
    if succeeded=true
        RunChannelStoreTask()
    end if
end sub

sub OnPurchaseError(event as object)
    error = event.GetData()
    m.productsScreen.loading = false
    print "Purchase Error: "; error
end sub