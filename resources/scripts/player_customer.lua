following = nil

function update()
    if following ~= nil then
        local trans = entity:get_transform().position
        local customer_env = following:get_scripts():get_script_env("customer.lua")
        customer_env.target_pos = vector2.new(trans.x, trans.y)
        customer_env.target_dist = 16.0
    end
end