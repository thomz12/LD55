function start()
    routine.create(function() 
        routine.wait_seconds_func(1.0, function(x)
            entity:get_ui_element().dimensions = vector2.new(
                out_elastic(x) * 128,
                out_elastic(x) * 64
            )
        end)
    end)
end

local time = 0.0
function update(delta_time)
    time = time + delta_time
    entity:get_ui_element().rotation = math.sin(time * 2) * 10
end