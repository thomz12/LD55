function show()
    if not entity:get_ui_element().enabled then

        local score = find_entity("text_score"):get_scripts():get_script_env("ui_score.lua").get_score()
        find_child_by_name(entity, "txt_score"):get_ui_text().text = "Score: " .. tostring(score)
        find_child_by_name(entity, "txt_score_1"):get_ui_text().text = "Score: " .. tostring(score)
        local highscore = load_string("really_not_the_highscore_that_you_can_easily_cheat")
        if highscore == "" then
            highscore = "0"
        end
        if score > tonumber(highscore) then
            save_string("really_not_the_highscore_that_you_can_easily_cheat", tostring(score))
            highscore = score
        end
        find_child_by_name(entity, "txt_high_score"):get_ui_text().text = "Highscore: " .. tostring(highscore)
        find_child_by_name(entity, "txt_high_score_1"):get_ui_text().text = "Highscore: " .. tostring(highscore)
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
                load_scene("scenes/menu.jbscene")
            end)
        end
    end
end