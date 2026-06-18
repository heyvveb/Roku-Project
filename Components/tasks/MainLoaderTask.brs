sub Init()
    m.top.functionName="GetContent"
end sub

sub GetContent()
    'request the content feed from the API
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.setURL("https://roku-project.onrender.com/Feed.json")
    rsp = xfer.GetToString()
    rootChildren = []
    rows = {}
    json = ParseJson(rsp)
    if json <> invalid
        categories = json.Keys()
        categories.Sort()
        for each category in categories
            value= json.Lookup(category)
            'if parsed key value have other objets in
            if Type(value) = "roArray"
                row = {}
                row.title= category
                row.children = []
                'parse items and push them to row
                for each item in value
                    itemData = GetItemData(item)
                    row.children.Push(itemData)
                end for
                rootChildren.push(row)
            end if
        end for
        'set up a root contentNode to representr rowList on the gridscreen
        contentNode = CreateObject("roSGNode" , "ContentNode")
        contentNode.Update({
            children: rootChildren
        },true)
        'populate content field with root content node
        m.top.content= contentNode
    end if
end sub

function GetItemData(video as object) as object
    item ={}
    if video.longDescription <> invalid
        item.description = video.longDescription
    else
        item.description = video.shortDescription
    end if
    item.hdPosterURL = video.thumbnail
    item.title = video.title
    item.releaseDate = video.releaseDate
    item.id = video.id
    if video.content <> invalid
        item.length = video.content.duration
    end if
    return item
end function