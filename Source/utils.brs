Function ContentListToSimpleNode(contentList as Object, nodeType ="ContentNode" as String) as Object
    result=CreateObject("roSGNode",nodeType)
    if result <> invalid
        for each itemAA in contentList
            item = CreateObject("roSGNode",nodeType)
            item.SetFields(itemAA)
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
    numOfChildren = content.GetChildCount()
    'Populate children array with items started from selected one
    children = node.GetChildren(numOfChildren - startItem, startItem)
    childrenClone = []
    'Go through each item of children array and clone them
    for each child in children
        childrenClone.Push(child.Clone(false))
    end for
    return childrenClone
end function