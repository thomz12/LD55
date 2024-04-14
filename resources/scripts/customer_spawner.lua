delay = 10.0
min_delay = 2.0

local waiting = 0
local waiting_customers = {}
local manager

local enabled = false

double_chance = 0.1
max_waiting_customers = 3
max_wait_time = 15
local current_wait_time = 0.0

function start()
    manager = find_entity("root"):get_scripts():get_script_env("game_manager.lua")
end

function start_spawning()
    enabled = true
    routine.create(function()
        while enabled and not manager.is_game_over() do
            spawn()
            if math.random() < double_chance then
                spawn()
            end
            routine.wait_seconds(delay)
            delay = delay * 0.95
            if (delay < min_delay) then delay = min_delay end
        end
    end)
end

function stop_spawning()
    enabled = false
end

function is_spawning()
    return enabled
end

function update(delta_time)
    if not manager.is_game_over() then
        if waiting >= max_waiting_customers then
            current_wait_time = current_wait_time + delta_time
            local progress_env = find_child_by_name(entity, "img_progress_back"):get_scripts():get_script_env("ui_progress.lua")
            progress_env.set_percentage(current_wait_time / max_wait_time)
            progress_env.show()

            if current_wait_time / max_wait_time >= 1.0 then
                manager.game_over(waiting_customers[1])
            end
        else
            current_wait_time = current_wait_time - delta_time
            local progress_env = find_child_by_name(entity, "img_progress_back"):get_scripts():get_script_env("ui_progress.lua")
            if current_wait_time <= 0.0 then
                current_wait_time = 0.0
                progress_env.hide()
            end
            progress_env.set_percentage(current_wait_time / max_wait_time)
        end
    end
end

function spawn()
    local customer = create_entity("customer")

    local transform = customer:add_transform()
    transform.position = vector3.new(
        entity:get_transform().position.x - waiting * 16,
        entity:get_transform().position.y,
        entity:get_transform().position.z)


    local sprite = customer:add_sprite()
    sprite.texture = texture.new("sprites/player.png")
    sprite.dimensions = vector2.new(16, 15)

    local physics = customer:add_physics()
    local box = box_shape.new()
    box.size = vector2.new(20, 20)
    box.isSensor = true
    physics.gravityScale = 0.0
    physics.boxes:add(box)
    customer:update_physics()

    local scripts = customer:add_scripts()
    scripts:add_script(load_script("scripts/customer.lua"))

    find_entity("img_entry_attention"):get_scripts():get_script_env("ui_popup.lua").show()
    waiting = waiting + 1
    table.insert(waiting_customers, customer)
end

function take_customer()
    if waiting > 0 then
        table.remove(waiting_customers, 1)

        waiting = waiting - 1
        if waiting == 0 then
            find_entity("img_entry_attention"):get_scripts():get_script_env("ui_popup.lua").hide()
        end

        routine.create(function()
            routine.wait_seconds_func(0.5, function(x)
                for i=1, waiting do
                    local customer = waiting_customers[i]
                    local x_pos = entity:get_transform().position.x - ((i) * 16)
                    local customer_trans = customer:get_transform()
                    customer_trans.position = vector3.new(
                        lerp(x_pos, x_pos + 16, x),
                        customer_trans.position.y,
                        customer_trans.position.z
                    )
                    customer:update_transform()
                end
            end)
        end)
    end
end