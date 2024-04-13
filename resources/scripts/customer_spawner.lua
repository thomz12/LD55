function start()
    spawn()
end

function update()
    if is_key_pressed("f1") then
        spawn()
    end
end

function spawn()
    local customer = create_entity("customer")

    local transform = customer:add_transform()
    transform.position = entity:get_transform().position

    local sprite = customer:add_sprite()
    sprite.texture = texture.new("sprites/player.png")
    sprite.dimensions = vector2.new(16, 16)

    local physics = customer:add_physics()
    local box = box_shape.new()
    box.size = vector2.new(20, 20)
    box.isSensor = true
    physics.gravityScale = 0.0
    physics.boxes:add(box)
    customer:update_physics()

    local scripts = customer:add_scripts()
    scripts:add_script(load_script("scripts/customer.lua"))

    find_entity("img_entry_attention"):get_scripts():get_script_env("ui_popup.lua").show()
end