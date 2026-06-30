'Include library of RAF
Library "Roku_Ads.brs"

sub init()
    m.top.functionName="PLayContentWithAds"
    m.top.id="PlayerTask"
end sub

'Retrieve all ads and configure it
sub PlayContentWithAds()
    'Node to wich the stitched stream
    parentNode=m.top.getParent()
    content = m.top.content
    m.top.lastIndex = m.top.startIndex
    items=content.GetChildren(-1,0)
    'Main entry point for instantianting the ad interface
    RAF=Roku_Ads()
    RAF.enableAdMeasurements(true)
    RAF.SetAdUrl("")

    KeepPlay=true
    index=m.top.startIndex -1
    itemsCount = items.Count()
    while keepPlay
        'check if playlist isn't complete
        if itemsCount -1 >index
            parentNode.SetFocus(true)
            index ++
            'contentNode of the video wich should be played next
            item = items[index]
            'Content detaisl used by RAF for ad targeting
            RAF.SetContentId(item.id)
            if item.categories <> invalid
                RAF.SetContentGenre(item.categories)
            end if
            RAF.SetContentLength(int(item.length))
            adPods = RAF.GetAds()
            'Combine video and ads into a single play list
            csasStream = RAF.constructStitchedStream(item, adPods)
            'render the stitched streakm
            keepPlay=RAF.renderStitchedStream(csasStream,parentNode)
        else
            keepPlay=false
        end if
    end while
end sub
