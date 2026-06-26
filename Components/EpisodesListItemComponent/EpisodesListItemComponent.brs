sub init()
    m.poster = m.top.findNode("poster")
    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
    m.info = m.top.findNode("info")
    m.title.font.size = 20
    m.description.font.size = 16
    m.info.font.size = 16
end sub

'When episode data is retrieved
sub itemContentChanged()
    'Episode metadata
    itemContent = m.top.itemContent
    if itemContent <> invalid
        'Populate components whi metadata
        m.poster.uri=itemContent.hdPosterUrl
        m.title.text = itemContent.title
        divider = " | "
        episode = "Game " + itemContent.episodePosition
        time = GetTime(itemContent.length)
        date = itemContent.releaseDate
        season = itemContent.titleSeason
        m.info.text = episode + divider +date + divider + time + divider + season
        m.description.text = itemContent.description
    end if
end sub
