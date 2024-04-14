scroll_speed = 16

local time = 0.0
local started = false

function start()
    find_entity("fade"):get_scripts():get_script_env("ui_panel.lua").fade_in(1.0)
end

function update(delta_time)
    time = time + delta_time
    local sprite = entity:get_sprite()
    sprite.origin.x = (sprite.origin.x + delta_time * scroll_speed) % 64
    for i, txt in ipairs(find_entities("text")) do
        txt:get_ui_text().color.a = (math.sin(time * 4.0) + 1.0) / 2.0
    end

    if not started then
        if is_key_held("space") then
            started = true
            find_entity("fade"):get_scripts():get_script_env("ui_panel.lua").fade_out(1.0, function()
                load_scene("scenes/main.jbscene")
            end)
        end
    end
end