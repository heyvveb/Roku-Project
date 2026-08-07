sub init()
    m.top.functionName = "GetCatalogFromStore"
end sub

'Query the Roku Channel Store catalog for this channel
sub GetCatalogFromStore()
    store = CreateObject("roChannelStore")
    port = CreateObject("roMessagePort")
    store.SetMessagePort(port)
    'Trigger the async catalog request
    store.GetCatalog()
    msg = wait(0, port)
    store.GetPurchases()
    purchasesmsg=wait(0,port)
    purchasesCodes=[]
    if type(msg) = "roChannelStoreEvent"
        'Check if the request happened
        succeeded = msg.isRequestSucceeded()
        if succeeded
            'Extract data from products
            products = msg.GetResponse()
            print "Products:"
            for each product in products
                print "Code: "; product.code; " name: "; product.name
            end for
            if type(purchasesmsg) = "roChannelStoreEvent" and purchasesMsg.isRequestSucceeded()
                'Extract data from products
                purchases=purchasesmsg.GetResponse()
                print "Purchases:"
                for each purchase in purchases
                    print "Code: "; purchase.code; " name: "; purchase.name
                    'add purchases codes to the list
                    purchasesCodes.Push(purchase.code)
                end for
            end if
            'add products to catalog node
            m.top.catalog = ContentListToSimpleNode(ConvertProductsToAA(products,purchasesCodes))
        else if msg.isRequestFailed()
            response = msg.GetResponse()
            print "ChannelStoreTask failed response: "; FormatJson(response)
            m.top.catalogError = "Failed to load catalog"
        else if msg.isRequestInterrupted()
            m.top.catalogError = "Catalog request was interrupted"
        end if
    else
        m.top.catalogError = "Timed out waiting for the Channel Store catalog"
    end if
end sub

'Convert products info to contentlist
function ConvertProductsToAA(products as object,purchases as object) as object
    result = []
    for each product in products
        item = {}
        item.id = product.code
        item.title = product.name
        item.description = product.name
        item.price = product.cost
        item.productType = product.productType
        'Check if the product was purchased
        item.isEntitled = IsCodeInList(product.code,purchases)
        result.Push(item)
    end for
    return result
end function
