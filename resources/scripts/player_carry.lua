local food_entities = {}

function start()
end

function add_food(food_texture)
    food_entity = create_entity("food")
    food_entity:add_transform()
    local sprite = food_entity:add_sprite()
    sprite.texture = texture.new("sprites/food.png")
    sprite.dimensions = vector2.new(16, 16)

    table.insert(food_entities, food_entity)
end

function pop_food()
    local food_entity = food_entities[#food_entities]
    table.remove(food_entities, #food_entities)
    return food_entity
end

function update()
    for i, food_entity in ipairs(food_entities) do
        local transform = food_entity:get_transform()
        transform.position = vector3.new(
            entity:get_transform().position.x,
            entity:get_transform().position.y + i * 8,
            0.0)
    end
end