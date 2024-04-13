
local original_zoom
local original_pos

function start()
    original_zoom = entity:get_camera().zoom
    original_pos = vector3.new(
        entity:get_transform().position.x, 
        entity:get_transform().position.y,
        entity:get_transform().position.z)
end

function zoom_in(position, zoom_amount, duration)
    routine.create(function()
        routine.wait_seconds_func(0.25, function(x)
            entity:get_transform().position = vector3.new(
                lerp(original_pos.x, position.x, x),
                lerp(original_pos.y, position.y, x),
                original_pos.z
            )
            entity:get_camera().zoom = original_zoom + x * zoom_amount
        end)

        routine.wait_seconds(duration)

        routine.wait_seconds_func(0.25, function(x)
            entity:get_transform().position = vector3.new(
                lerp(position.x, original_pos.x, x),
                lerp(position.y, original_pos.y, x),
                original_pos.z
            )
            entity:get_camera().zoom = original_zoom + (1.0 - x) * zoom_amount
        end)
    end)
end