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