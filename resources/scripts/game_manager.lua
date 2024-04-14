local over = false
local score = 0.0

-- function start()
--     playfab_login("thom", function(result, ticket, new_account)
--         if result then
--             info("Signed in!")
--             info(ticket)
--             if new_account then
--                 info("New account created!")
--             end
--         else
--             info("Something went wrong!")
--         end
--     end)
-- end

function is_game_over()
    return over
end

function game_over(reason_entity)
    if not over then
        over = true
        entity:get_audio():stop()
        find_entity("game_over_sound"):get_audio():play()
        find_entity("camera"):get_scripts():get_script_env("camera.lua").zoom_in(
            vector2.new(reason_entity:get_transform().position.x, reason_entity:get_transform().position.y), 2.0, 10000.0)
        reason_entity:get_scripts():get_script_env("customer.lua").die(function()
            find_entity("ui_game_over"):get_scripts():get_script_env("ui_game_over.lua").show()
        end)
    end
end