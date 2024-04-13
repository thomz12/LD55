following = nil

function update()
    if following ~= nil then
        local trans = entity:get_transform().position
        local customer_env = following:get_scripts():get_script_env("customer.lua")
        customer_env.target_pos = vector2.new(trans.x, trans.y)
        customer_env.target_dist = 16.0

        local tables = find_entities("table")
        for i, tbl in ipairs(tables) do
            if tbl:get_scripts():get_script_env("table.lua").customer == nil then
                find_child_by_name(tbl, "img_table_attention"):get_scripts():get_script_env("ui_popup.lua").show("sprites/ui_arrow.png")
            end
        end
    end
end