Function ContentListToSimpleNode(contentList as Object, nodeType ="ContentNode" as String) as Object
    result=CreateObject("roSGNode",nodeType)
    if result <> invalid
        for each itemAA in contentList
            item = CreateObject("roSGNode",nodeType)
            item.SetFields(itemAA)
            item.AddField("isEntitled", "boolean", false)
            item.isEntitled = itemAA.isEntitled
            result.AppendChild(item)
        end for
    end if
    return result
end function

function GetTime(length as Integer) as String
    minutes = (length \ 60).ToStr()
    seconds = length MOD 60
    if seconds < 10
       seconds = "0" + seconds.ToStr()
    else
       seconds = seconds.ToStr()
    end if
    return minutes + ":" + seconds
end function

function CloneChildren(node as object, startItem = 0 as Integer)
    'Get number of row items
    numOfChildren = node.GetChildCount()
    'Populate children array with items started from selected one
    children = node.GetChildren(numOfChildren - startItem, startItem)
    childrenClone = []
    'Go through each item of children array and clone them
    for each child in children
        childrenClone.Push(child.Clone(false))
    end for
    return childrenClone
end function

'Finds child node by content id
function findNodeById(content as object, contentId as string) as object
    for each element in content.GetChildren(-1,0)
        if element.id=contentId
            return element
        else if element.GetChildCount()>0
            result = findNodeById(element,contentId)
            if result <> invalid
                return result
            end if
        end if
    end for
    return invalid
end function

'Reads and return the value of the specified key
function RegRead(key as string, section = invalid as Dynamic) as dynamic
    if section = invalid then section = "Default"
    reg = CreateObject("roRegistrySection",section)
    if reg.Exists(key) then return reg.Read(key)
    return invalid
end function

'replaces the value of the especified key
sub RegWrite(key as string, val as string, section = invalid as dynamic)
    if section = invalid then section = "Default"
    reg = CreateObject("roRegistrySection", section)
    reg.Write(key, val)
    reg.Flush()
end sub

'Deteles the specified key
sub RegDelete(key as String, section = invalid as dynamic)
    if section = invalid then section = "Default"
    reg = CreateObject("roRegistrySection", section)
    reg.Delete(key)
    reg.Flush()
end sub

'Get codes for valid products to play videos
function GetProductsCodes()
    Code=[
    "com.nfl.gamecenter.2021.NFLPLUS.YEARLY",
    "com.nfl.gamecenter.2021.GAMEPASS.SEASON"
    ]
    return Code
end function

'Check if the purchase codes are on the list of valid product codes.
function IsCodeInList(code as string, list as object) as boolean
    for each validCode in list
        if code = validCode
            return true
        end if
    end for
    return false
end function