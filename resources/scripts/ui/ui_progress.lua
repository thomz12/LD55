local bar

local minWidth = -16
local maxWidth = -2

function start()
    bar = find_child_by_name(entity, "img_progress_bar")
end

function show()
    entity:get_ui_element().enabled = true
end

function hide()
    entity:get_ui_element().enabled = false
end

function set_percentage(percentage)
    if percentage > 1.0 then
        percentage = 1.0
    end
    bar:get_ui_element().dimensions.x = lerp(minWidth, maxWidth, percentage)
end