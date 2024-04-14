local total_score = 0

local shadow

function start()
    shadow = find_child_by_name(entity, "text_score_1")
end

function get_score()
    return total_score
end

function add_score(score)
    total_score = total_score + score
    entity:get_ui_text().text = tostring(total_score)
    find_child_by_name(entity, "text_score_1"):get_ui_text().text = tostring(total_score)

    routine.create(function()
        routine.wait_seconds_func(0.25, function(x)
            entity:get_ui_text().fontSize = 12 + (1 - x) * 4
            shadow:get_ui_text().fontSize = 12 + (1 - x) * 4
        end)
    end)
end