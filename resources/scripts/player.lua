player_speed = 16

function update(delta_time)

    local any_input = false
    local velocity = vector2.new()
    local transform = entity:get_transform()

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
    end

    entity:get_physics():set_velocity(velocity)
end