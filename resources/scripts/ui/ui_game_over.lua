function show()
    if not entity:get_ui_element().enabled then
        routine.create(function()
            routine.wait_seconds_func(0.5, function(x)
                entity:get_ui_element().enabled = true
                entity:get_ui_element().anchor.y = 0.5 - in_back(1.0 - x)
            end)
        end)
    end
end

local loading = false

function update()
    if entity:get_ui_element().enabled then
        if not loading and is_key_held("space") then
            loading = true
            find_entity("panel_fade"):get_scripts():get_script_env("ui_panel.lua").fade_out(1.0, function()
                load_scene("scenes/main.jbscene")
            end)
        end
    end
end