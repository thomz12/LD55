local color

function start()
    color = entity:get_ui_9_slice().color
end

function on_ui_mouse_enter()
    entity:get_ui_9_slice().color = color.new(1, 1, 1, 1)
end

function on_ui_mouse_leave()
    entity:get_ui_9_slice().color = color.new(0, 0, 0, 1)
end