sub inti()
    m.top.functionName="GetContent"
end sub

sub GetContent()
    'request the content feed from the API
    xfer = CreateObject(roURLTransfer)
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.setURL("https://jonathanbduvel.com/roku/feeds/roku-developers-feed-v1.json")
    rsp = xfer.GetToString()