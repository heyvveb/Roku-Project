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
    msg = wait(45000, port)
    if type(msg) = "roChannelStoreEvent"
        'Check if the request happened
        succeeded = msg.isRequestSucceeded()
        if succeeded
            'Extract data from products
            products = msg.GetResponse()
            'add products to catalog node
            m.top.catalog = ContentListToSimpleNode(ConvertProductsToAA(products))
        else if msg.isRequestFailed()
            m.top.catalogError = msg.GetMessage()
        else if msg.isRequestInterrupted()
            m.top.catalogError = "Catalog request was interrupted"
        end if
    else
        m.top.catalogError = "Timed out waiting for the Channel Store catalog"
    end if
end sub

'Convert products info to contentlist
function ConvertProductsToAA(products as object) as object
    result = []
    for each product in products
        item = {}
        item.id = product.code
        item.title = product.name
        item.description = product.name
        item.price = product.cost
        item.productType = product.type
        item.span = product.span
        item.isEntitled = product.isEntitled
        result.Push(item)
    end for
    return result
end function
