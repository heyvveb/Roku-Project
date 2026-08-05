sub init()
    m.top.functionName = "DoPurchase"
end sub

sub DoPurchase()
    code = m.top.productCode
    'When code is invalid or empty
    if code = invalid or code = ""
        m.top.purchaseError = "No product code provided"
        return
    end if
    store = CreateObject("roChannelStore")
    port = CreateObject("roMessageport")
    store.SetMessagePort(port)
    'reset the order flow
    store.ClearOrder()
    'Order Item atributes
    orderItem={
        code:code
        qty:1
    }
    store.SetOrder([orderItem])
    'Roku Pay interface is deployed
    store.DoOrder()
    'wait buy response
    msg = wait(0,port)
    if type(msg)= "roChannelStoreEvent"
        if msg.isRequestSucceeded()
            m.top.purchaseSucceeded = true
        else if msg.isRequestFailed()
            response = msg.GetResponse()
            print "PurchaseTask failed response: "; FormatJson(response)
            m.top.purchaseError="Product purchase failure"
        else if msg.isRequestInterrupted()
            m.top.purchaseError = "Purchase was canceled"
        end if
    else
        m.top.purchaseError= "Unexpected response from Channel Store"
    end if
end sub