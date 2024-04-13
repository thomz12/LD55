sizeX = 16
sizeY = 16
height = 16

local time = 0

function show(texture_name)
    if texture_name ~= nil then
        entity:get_ui_image().image = texture.new(texture_name)
    end

    if not entity:get_ui_element().enabled then
        entity:get_ui_element().dimensions = vector2.new(0, 0)
        entity:get_ui_element().enabled = true
        routine.create(function()
            routine.wait_seconds_func(0.5, function(x)
                entity:get_ui_element().dimensions = vector2.new(
                    sizeX * out_back(x),
                    sizeY * out_back(x)
                )
            end)
        end)
    end
end

function hide()
    if entity:get_ui_element().enabled then
        entity:get_ui_element().dimensions = vector2.new(sizeX, sizeY)
        routine.create(function()
            routine.wait_seconds_func(0.25, function(x)
                entity:get_ui_element().dimensions = vector2.new(
                    sizeX * out_quart(1 - x),
                    sizeY * out_quart(1 - x)
                )
            end)
            entity:get_ui_element().enabled = false
        end)
    end
end

function update(delta_time)
    time = time + delta_time
    local element = entity:get_ui_element()
    if element.enabled then
        element.offset.y = height + math.sin(time * 4) * 2
    end
end