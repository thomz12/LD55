function fade_in(duration, on_finish)
    routine.create(function()
        routine.wait_seconds_func(duration, function(x)
            local panel = entity:get_ui_panel()
            panel.color = color.new(0, 0, 0, 1 - x)
        end)
        on_finish()
    end)
end

function fade_out(duration, on_finish)
    routine.create(function()
        routine.wait_seconds_func(duration, function(x)
            local panel = entity:get_ui_panel()
            panel.color = color.new(0, 0, 0, x)
        end)
        on_finish()
    end)
end