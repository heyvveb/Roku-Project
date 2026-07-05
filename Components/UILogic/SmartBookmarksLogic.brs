function MasterChannelSmartBookmarks()
    this = {
        LoadSmartBookmarks: LoadSmartBookmarks
        SaveSmartBookmarks: SaveSmartBookmarks
        UpdateSmartBookmarkForSeries: UpdateSmartBookmarkForSeries
        GetSmartBookmarkForSeries: GetSmartBookmarkForSeries
        RemoveSmartBookmarkForSeries: RemoveSmartBookmarkForSeries
    }
    return this
end function

'Read all smart bookmarks
sub LoadSmartBookmarks()
    m.smartBookmarks = []
    raw = RegRead("smartBookmarks","master_channel_bookmarks")
    if raw <> invalid
        m.smarBookmarks = ParseJson(raw)
    end if
end sub

'Save all smart bookmarks to the registry
sub SaveSmartBookmarks()
    RegWrite("smartBookmarks", FormatJson(m.smarBookmarks),"master_channel_bookmarks")
end sub

'Update smart bookmark for specified series
sub UpdateSmartBookmarkForSeries(id, episodeId)
    if id = invalid or episdeId = invalid
        m.LoadSmartBookmarks()
    end if
    success = false
    'Trye to find smart bookmark for specified series and update it
    for each bookmark in m.smarBookmarks
        if bookmark.id = id
            bookmark.episodeId = episodeId
            success=true
            exit for
        end if
    end for
    'add new smart bookmark if bookmark for specified series doesnt exist
    if not success
        m.smarBookmarks.Push({
            id: id
            episodeId: episodeId
        })
    end if
    'Save last changes
    m.SaveSmartBookmarks()
end sub

'return last played episode id for specified series
function GetSmartBookmarkForSeries(id as String) as String
    result = ""
    'Read smart booksmarks from registry if neaded
    if m.smartBookmarks = invalid
        m.LoadSmartBookmarks()
    end if
    'Try to find bookmark for specified series
    for each bookmark in m.smartBookmarks
        if bookmark.id = id
            result = bookmark.episodeId
            exit for
        end if
    end for
    return result
end function

'Remove smart bookmark if user finishied series
sub RemoveSmartBookmarkForSeries(id as String)
    if m.smarBookmarks = invalid
        m.LoadSmartBookmarks()
    end if
    for i = 0 to m.smarBookmarks.Count() - 1
        bookmark = m.smarBookmarks[i]
        if bookmark.id = id
            m.smarBookmarks.Delete(i)
            exit for
        end if
    end for
    'Save last update to the local registry
    m.SaveSmartBookmarks()
end sub
