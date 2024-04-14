-- player movement speed
player_speed = 16

-- duration of one animation frame
player_frame_dur = 0.2

player_show_tutorial_time = 5.0

local moved = false
local frame_timer = 0.0
local tutorial_timer = 0.0
local tutorial_triggered = false

local manager

function start()
    manager = find_entity("root"):get_scripts():get_script_env("game_manager.lua")
end

function update(delta_time)
    if manager.is_game_over() then
        entity:get_physics():set_velocity(vector2.new(0, 0))
        return
    end
    -- get components
    local transform = entity:get_transform()
    local sprite = entity:get_sprite()

    if not moved then
        tutorial_timer = tutorial_timer + delta_time
        if not tutorial_triggered and tutorial_timer > player_show_tutorial_time then
            tutorial_triggered = true
            routine.create(function()
                routine.wait_seconds_func(0.5, function(x)
                    entity:get_ui_image().color = color.new(1, 1, 1, x)
                end)
            end)
        end
    end

    -- take input
    local any_input = false
    local velocity = vector2.new()
    if is_key_held("a") or is_key_held("left") then
        any_input = true
        velocity.x = -1
        transform.scale.x = -1
    end
    if is_key_held("d") or is_key_held("right") then
        any_input = true
        velocity.x = 1
        transform.scale.x = 1
    end
    if is_key_held("w") or is_key_held("up") then
        any_input = true
        velocity.y = 1
    end
    if is_key_held("s") or is_key_held("down") then
        any_input = true
        velocity.y = -1
    end

    if any_input == true then 
        if not moved then
            if tutorial_triggered then
                routine.create(function()
                    routine.wait_seconds_func(3.0, function(x)
                        entity:get_ui_image().color = color.new(1, 1, 1, 1-x)
                    end)
                end)
            end
            moved = true
            find_entity("customer_spawner"):get_scripts():get_script_env("customer_spawner.lua").spawn()
        end
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