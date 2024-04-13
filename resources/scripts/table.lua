local has_customer = false

function on_contact(this, other)
    if not has_customer and other.name == "player" then
        local player_customer_env = other:get_scripts():get_script_env("player_customer.lua")
        -- check if a customer is following the player.
        -- if it is, target the customer to this table.
        if player_customer_env.following ~= nil then
            has_customer = true
            local customer = player_customer_env.following
            local customer_env = customer:get_scripts():get_script_env("customer.lua")
            local pos = entity:get_transform().position
            customer_env.target_pos = vector2.new(pos.x - 12, pos.y + 4)
            customer_env.target_dist = 4.0
            customer_env.seat_customer()
            player_customer_env.following = nil
            bounce()
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