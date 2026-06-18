sub RunContentTask()
    'Create task for feed retrieving
    m.contentTask = CreateObject("roSGNode" , "MainLoaderTask")
    'observer content 
    m.contentTask.ObserveField("content" , "OnMainContentLoaded")
    m.contentTask.control = "run"
    'Show loading indicator while content is loading
    m.loadingIndicator.visible = true
    'Hide overhang
    m.overhang.visible = false
    m.overhangTitle.visible = false
end sub

'invoked when content is ready to be used
sub OnMainContentLoaded()
    'focus to gridscreen 
    m.GridScreen.SetFocus(true) 
    'hide loading indicator 
    m.loadingIndicator.visible = false
    'Make visible overhang
    m.overhang.visible = true
    m.overhangTitle.visible = true
    'add gridscreen whit content
    m.GridScreen.content = m.contentTask.content 
end sub
