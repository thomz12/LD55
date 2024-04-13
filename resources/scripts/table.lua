customer = nil

function on_contact(this, other)
    if other.name == "player" then
        if customer == nil then
            local player_customer_env = other:get_scripts():get_script_env("player_customer.lua")
            -- check if a customer is following the player.
            -- if it is, target the customer to this table.
            if player_customer_env.following ~= nil then

                local tables = find_entities("table")
                for i, tbl in ipairs(tables) do
                    if tbl:get_scripts():get_script_env("table.lua").customer == nil then
                        find_child_by_name(tbl, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").hide()
                    end
                end

                customer = player_customer_env.following
                local customer_env = customer:get_scripts():get_script_env("customer.lua")
                local pos = entity:get_transform().position
                customer_env.seat_customer(entity)
                if math.random(0, 1) == 0 then
                    customer_env.move_towards(vector2.new(pos.x - 12, pos.y + 4), 1.0, function()
                        customer:get_transform().scale.x = 1
                    end)
                else
                    customer_env.move_towards(vector2.new(pos.x + 12, pos.y + 4), 1.0, function()
                        customer:get_transform().scale.x = -1
                    end)
                end
                customer_env.target_pos = nil
                customer_env.target_dist = 0.0
                player_customer_env.following = nil
                bounce()
            end
        else
            -- pass collision along to customer
            customer:get_scripts():get_script_env("customer.lua").on_contact(customer, other)
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