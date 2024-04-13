-- player movement speed
player_speed = 16

-- duration of one animation frame
player_frame_dur = 0.2

local frame_timer = 0.0

function update(delta_time)
    -- get components
    local transform = entity:get_transform()
    local sprite = entity:get_sprite()

    -- take input
    local any_input = false
    local velocity = vector2.new()
    if is_key_held("a") then
        any_input = true
        velocity.x = -1
        transform.scale.x = -1
    end
    if is_key_held("d") then
        any_input = true
        velocity.x = 1
        transform.scale.x = 1
    end
    if is_key_held("w") then
        any_input = true
        velocity.y = 1
    end
    if is_key_held("s") then
        any_input = true
        velocity.y = -1
    end

    if any_input == true then 
        velocity:normalize()
        velocity.x = velocity.x * player_speed
        velocity.y = velocity.y * player_speed

        -- walking animation
        frame_timer = frame_timer + delta_time
        if frame_timer > player_frame_dur then
            frame_timer = 0.0
            sprite.origin.x = (sprite.origin.x + 16) % (16 * 4)
        end
    else
        -- back to standing frame when not moving
        sprite.origin.x = 0
    end

    entity:get_physics():set_velocity(velocity)
end