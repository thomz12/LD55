function start()
    find_entity("panel_fade"):get_scripts():get_script_env("ui_panel.lua").fade_in(0.5, function() 
        -- game start!
    end)
    find_entity("panel_fade"):get_ui_panel().color = color.new(0, 0, 0, 1)
end