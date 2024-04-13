local frame_timer = 0.0

target_pos = nil
target_dist = nil

local interact_func = nil
local table = nil
local entry_pos = nil

-- customer states:
-- 0: wait to be seated (needs player)
-- 1: following waiter
-- 2: deciding what to eat
-- 3: ready to order (needs player)
-- 4: waiting for food (needs player)
-- 5: eating
-- 6: ready to pay (needs player)
-- 7: leaving

function start()
    entity:get_sprite().origin = vector2.new(0, 16 * math.random(1, 3))
    interact_func = wait_interact
    entry_pos = vector2.new(90, 90)
end

function update(delta_time)
    local sprite = entity:get_sprite()
    local transform = entity:get_transform()
    if target_pos ~= nil then
        local my_pos = transform.position
        local dir = vector2.new(my_pos.x - target_pos.x, my_pos.y - target_pos.y)
        if math.abs(dir.x) > target_dist or math.abs(dir.y) > target_dist then
            transform.position = vector3.new(
                my_pos.x - dir.x * 0.9 * delta_time,
                my_pos.y - dir.y * 0.9 * delta_time,
                my_pos.z
            )

            if dir.x < 0.0 then
                transform.scale.x = 1
            else
                transform.scale.x = -1
            end

            entity:update_transform()

            -- walking animation
            frame_timer = frame_timer + delta_time
            if frame_timer > 0.1 then
                frame_timer = 0.0
                sprite.origin.x = (sprite.origin.x + 16) % (16 * 4)
            end
        else
            sprite.origin.x = 0
        end
    end
end

function wait_payment(player)
    table:get_scripts():get_script_env("table.lua").customer = nil
    find_child_by_name(table, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").hide()
    interact_func = nil
    target_pos = entry_pos
    target_dist = 1.0

    if not find_entity("customer_spawner"):get_scripts():get_script_env("customer_spawner.lua").is_spawning() then
        find_entity("customer_spawner"):get_scripts():get_script_env("customer_spawner.lua").start_spawning()
    end
end

function wait_food(player)
    if player:get_scripts():get_script_env("player_food.lua").get_order() then
        find_child_by_name(table, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").hide()
        local food_entity = player:get_scripts():get_script_env("player_carry.lua").pop_food()
        local food_startX = food_entity:get_transform().position.x
        local food_startY = food_entity:get_transform().position.y
        routine.create(function()
            routine.wait_seconds_func(1.0, function(x)
                local food_trans = food_entity:get_transform()
                local table_trans = table:get_transform()
                food_trans.position.x = lerp(food_startX, table_trans.position.x, out_expo(x))
                food_trans.position.y = lerp(food_startY, table_trans.position.y + 2, out_bounce(x))
                food_trans.rotation = lerp(0, 360, out_back(x))
            end)
        end)

        interact_func = nil
        bounce()
        routine.create(function()
            routine.wait_seconds(5.0)
            destroy_entity(food_entity)
            find_child_by_name(table, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").show("sprites/ui_payment.png")
            interact_func = wait_payment
        end)
    end
end

function seat_customer(my_table)
    table = my_table
    routine.create(function()
        routine.wait_seconds(4.0)
        bounce()
        find_child_by_name(table, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").show("sprites/ui_order.png")
        interact_func = function(player)
            interact_func = wait_food
            player:get_scripts():get_script_env("player_food.lua").add_order()
            find_child_by_name(table, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").show("sprites/ui_food.png")
            bounce()
        end
    end)
end

function wait_interact(player)
    local player_customer_env = player:get_scripts():get_script_env("player_customer.lua")
    if player_customer_env.following == nil then
        player_customer_env.following = entity
        find_entity("img_entry_attention"):get_scripts():get_script_env("ui_popup.lua").hide()
        interact_func = nil
        bounce()
    end
end

function on_contact(this, other)
    if other.name == "player" then
        if interact_func ~= nil then
            interact_func(other)
        end
    end
end

function bounce()
    routine.create(function()
        routine.wait_seconds_func(0.5, function(x)
            local transform = entity:get_transform()
            local scale = 1.0 + (0.5 * in_elastic(1.0 - x))
            transform.scale = vector2.new(scale, scale)
        end)
    end)
end