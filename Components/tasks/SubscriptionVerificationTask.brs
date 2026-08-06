sub init()
    m.top.functionName="CheckSuscription"
end sub

sub CheckSuscription()
    'Get valid codes
    codes = m.top.productsCodes
    if codes=invalid or codes.count()=0
        m.top.entitedError="No product codes provided"
        m.top.isEntited=false
        return
    end if
    store = CreateObject("roChannelStore")
    port = CreateObject("roMessagePort")
    store.SetMessagePort(port)
    'ask for the user purchases or subscriptions
    store.GetPurchases()
    msg = wait(0,port)
    if type(msg)="roChannelStoreEvent"
        if msg.isRequestSucceeded()
            'Get information of purchases
            purchases=msg.GetResponse()
            entitled = false
            matchcode=""
            for each purchase in purchases
                'Check if purchase code is in valid codes
                if IsCodeInList(purchase.code, codes)
                    entitled = true
                    matchcode=purchase.code
                    exit for
                end if
            end for
            m.top.entitledCode=matchcode
            m.top.isEntited = entitled
        else if msg.isRequestFailed()
            m.top.entitedError = "Failed to check purchases"
            m.top.isEntited = false
        else if msg.isRequestInterrupted()
            m.top.entitedError = "Entitlement check interrupted"
            m.top.isEntited = false
        end if
    end if
end sub

