local frame_timer = 0.0

target_pos = nil
target_dist = nil

local waiting = false
local patience = 0.0
local max_patience = 15.0

local interact_func = nil
local table = nil
local entry_pos = nil
local delta
local manager

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
    manager = find_entity("root"):get_scripts():get_script_env("game_manager.lua")
    entity:get_sprite().origin = vector2.new(0, 16 * math.random(1, 8))
    interact_func = wait_interact
    entry_pos = vector2.new(90, 90)
end

function move_towards(position, duration, on_arrive)
    local start_pos = vector2.new(entity:get_transform().position.x, entity:get_transform().position.y)
    routine.create(function()
        routine.wait_seconds_func(duration, function(x)
            -- walking animation
            local sprite = entity:get_sprite()
            frame_timer = frame_timer + delta
            if frame_timer > 0.1 then
                frame_timer = 0.0
                sprite.origin.x = (sprite.origin.x + 16) % (16 * 4)
            end

            local transform = entity:get_transform()
            transform.position = vector3.new(
                lerp(start_pos.x, position.x, x),
                lerp(start_pos.y, position.y, x),
                transform.position.z
            )
            entity:update_transform()
        end)
        local sprite = entity:get_sprite()
        sprite.origin.x = 0
        on_arrive()
    end)
end

function die(on_death)
    routine.create(function()
        local xpos = entity:get_transform().position.x
        local ypos = entity:get_transform().position.y
        routine.wait_seconds_func(2.5, function(x)
            entity:get_transform().position.x = xpos + (math.random() - 0.5) * 2
            entity:get_transform().position.y = ypos + (math.random() - 0.5) * 2
            entity:update_transform()
        end)
        routine.wait_seconds(0.5)
        routine.wait_seconds_func(0.5, function(x)
            entity:get_transform().rotation = x * 90
            entity:get_transform().position.y = ypos - x * 5
            entity:update_transform()
        end)
        on_death()
    end)
end

function update(delta_time)
    if manager.is_game_over() then return end
    if waiting then
        patience = patience + delta_time
        if table ~= nil then
            local progress_bar_env = find_child_by_name(table, "img_progress_back"):get_scripts():get_script_env("ui_progress.lua")
            progress_bar_env.set_percentage(patience / max_patience)

            if patience / max_patience > 1.0 then
                find_child_by_name(table, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").hide()
                manager.game_over(entity)
            end
        end
    end
    delta = delta_time
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

function set_wait(new_wait)
    if waiting ~= new_wait then
        waiting = new_wait
        local progress_bar_env = find_child_by_name(table, "img_progress_back"):get_scripts():get_script_env("ui_progress.lua")
        if waiting then
            progress_bar_env.show()
        else
            progress_bar_env.hide()
        end
    end 
end

function wait_payment(player)
    table:get_scripts():get_script_env("table.lua").customer = nil
    find_child_by_name(table, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").hide()
    interact_func = nil
    find_entity("sound_money"):get_audio():play()
    add_score("Accept Payment", 200)
    entity:get_transform().scale.x = -1
    set_wait(false)
    routine.create(function()
        routine.wait_seconds(3.0)
        routine.wait_seconds_func(1.0, function(x)
            entity:get_sprite().color.a = 1.0 - x
        end)
    end)

    move_towards(entry_pos, 4.0, function()
        destroy_entity(entity)
    end)
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
        find_entity("sound_throw"):get_audio():play()
        add_score("Deliver Order", 100)
        routine.create(function()
            routine.wait_seconds_func(1.0, function(x)
                local food_trans = food_entity:get_transform()
                local table_trans = table:get_transform()
                food_trans.position.x = lerp(food_startX, table_trans.position.x, out_expo(x))
                food_trans.position.y = lerp(food_startY, table_trans.position.y + 2, out_bounce(x))
                food_trans.rotation = lerp(0, 360, out_back(x))
            end)
        end)
        set_wait(false)
        interact_func = nil
        bounce()
        routine.create(function()
            routine.wait_seconds_func(5.0, function(x)
                if math.floor(x * 50) % 2 == 0 then
                    entity:get_sprite().origin.x = 0.0
                else
                    entity:get_sprite().origin.x = 64.0
                end
            end)
            entity:get_sprite().origin.x = 0.0
            set_wait(true)
            destroy_entity(food_entity)
            find_child_by_name(table, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").show("sprites/ui_payment.png")
            interact_func = wait_payment
        end)
    end
end

function add_score(desc, score)
    find_entity("player"):get_scripts():get_script_env("player_score.lua").add_score(desc, score)
end

function seat_customer(my_table)
    table = my_table
    find_entity("sound_follow"):get_audio():play()
    add_score("Seat Customer", 100)
    routine.create(function()
        routine.wait_seconds(2.0)
        bounce()
        set_wait(true)
        find_child_by_name(table, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").show("sprites/ui_order.png")
        interact_func = function(player)
            add_score("Take Order", 100)
            find_entity("sound_write"):get_audio():play()
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
        find_entity("sound_follow"):get_audio():play()
        find_entity("customer_spawner"):get_scripts():get_script_env("customer_spawner.lua").take_customer()
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
    scaleX = entity:get_transform().scale.x
    routine.create(function()
        routine.wait_seconds_func(0.5, function(x)
            local transform = entity:get_transform()
            local scale = 1.0 + (0.5 * in_elastic(1.0 - x))
            if scaleX < 0.0 then scale = scale * -1.0 end
            transform.scale = vector2.new(scale, math.abs(scale))
        end)
    end)
end