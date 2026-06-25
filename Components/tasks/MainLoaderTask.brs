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
                    seasons = GetSeasonData(item.seasons)
                    itemData.mediaType= category
                    if seasons <> invalid and season.Count() > 0
                        itemData.children = seasons
                    end if
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
    if video.episodeNumber <> invalid
        item.episodePosition = video.episodeNumber.ToStr()
    end if
    if video.content <> invalid
        item.length = video.content.duration
        item.url = video.content.videos[0].url
        item.streamFormat = video.content.videos[0].videoType
    end if
    return item
end function

function GetSeasonData(seasons as object) as object
    seasonsArray = []
    if seasons <> invalid
        episodeCounter = 0
        for each season in seasons
            if season.episodes <> invalid
                episodes = []
                for each episode in season.episodes
                    episodeData = GetItemData(episode)
                    'Save season title for element to represent it on the episodes screen
                    episodeData.titleSeason = season.title
                    episodeData.numEpisodes = episodeCounter
                    episodeData.mediaType = "episode"
                    episodes.Push(episodeData)
                    episodeCounter++
                end for
                seasonData = GetItemData(season)
                'populate season's children field whit its episodes
                seasonData.children = episodes
                'Set content type for season object to repesent it on the screen
                seasonData.contentType ="section"
                seasonsArray.push(seasonData)
            end if
        end for
    end if
    return seasonsArray
end function