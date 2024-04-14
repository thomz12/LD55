local score_text_env
local score_parent

local score_entities = {}

function start()
    score_parent = find_entity("score_root")
    score_text_env = find_entity("text_score"):get_scripts():get_script_env("ui_score.lua")
end

function add_score(description, score)
    score_text_env.add_score(score)
    local new_entity = create_entity("score")
    parent_entity(new_entity, score_parent)
    local text = new_entity:add_ui_text()
    text.text = description .. " +" .. tostring(score)
    text.fontSize = 5.0
    text.font = load_font("fonts/aldo_the_apache.ttf")

    routine.create(function()
        local score_ent = new_entity
        local posX = entity:get_transform().position.x
        local posY = entity:get_transform().position.y
        routine.wait_seconds_func(1.5, function(x)
            local element = score_ent:get_ui_element()
            local text = score_ent:get_ui_text()
            element.offset = vector2.new(posX, posY + x * 16)
            text.color = color.new(1, 1, 1, out_back(1 - x))
        end)
        destroy_entity(score_ent)
    end)
end