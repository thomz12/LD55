local orders = 0
local carrying = 0

function get_order()
    if carrying > 0 then
        carrying = carrying - 1
        return true
    end
    return false
end

function add_order()
    if orders == 0 then
        find_entity("img_attention_food"):get_scripts():get_script_env("ui_popup.lua").show()
    end
    orders = orders + 1
end

function on_contact(this, other)
    if other.name == "kitchen" then
        if orders > 0 then 
            find_entity("sound_write"):get_audio():play()
        end
        carrying = carrying + orders
        find_entity("img_attention_food"):get_scripts():get_script_env("ui_popup.lua").hide()
        for i=1, orders do
            entity:get_scripts():get_script_env("player_carry.lua").add_food(0)
        end
        orders = 0
    end
end