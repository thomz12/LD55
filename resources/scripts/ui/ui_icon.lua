function start()
    routine.create(function()
        routine.wait_seconds_func(1, function(x)
            local element = entity:get_ui_element()
            element.dimensions.x = out_elastic(x) * 128
            element.dimensions.y = out_elastic(x) * 128
        end)
        -- Fade out and load main scene.
        find_entity("panel_fade"):get_scripts():get_script_env("ui_panel.lua").fade_out(0.5, function() 
            load_scene("scenes/main.jbscene")
        end)
    end)
    routine.create(function()
        routine.wait_seconds_func(1, function(x)
            local element = entity:get_ui_element()
            element.rotation = 90 - out_elastic(x) * 90
        end)
    end)
end