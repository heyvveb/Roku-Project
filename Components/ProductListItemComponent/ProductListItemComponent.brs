sub init()
    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
    m.price = m.top.findNode("price")
end sub
'Change content if scroll
sub OnContentSet()
    content = m.top.itemContent
    if content <> invalid
        m.title.text = content.title
        m.description.text = content.description
        if content.isEntitled = true
            m.price.text = "Owned"
        else
            m.price.text = content.price
        end if
    end if
end sub