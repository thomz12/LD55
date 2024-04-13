sizeX = 16
sizeY = 16
height = 16

local time = 0

function show(texture_name)
    if texture_name == nil then
        texture_name = "sprites/ui_attention.png"
    end

    entity:get_ui_element().enabled = true
    entity:get_ui_image().image = texture.new(texture_name)
end

function hide()
    entity:get_ui_element().enabled = false
end

function update(delta_time)
    time = time + delta_time
    local element = entity:get_ui_element()
    if element.enabled then
        element.offset.y = height + math.sin(time * 4) * 2
    end
end