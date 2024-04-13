following = nil

function update()
    if following ~= nil then
        local trans = entity:get_transform().position
        following:get_scripts():get_script_env("customer.lua").target_pos = vector2.new(trans.x, trans.y)
        following:get_scripts():get_script_env("customer.lua").target_dist = 16.0
    end
end