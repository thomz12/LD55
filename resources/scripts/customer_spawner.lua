delay = 10.0
min_delay = 2.0

local waiting = 0
local waiting_customers = {}

local enabled = false

double_chance = 0.1

function start_spawning()
    enabled = true
    routine.create(function()
        while enabled do
            spawn()
            if math.random() < double_chance then
                spawn()
            end
            routine.wait_seconds(delay)
            delay = delay * 0.95
            if (delay < min_delay) then delay = min_delay end
        end
    end)
end

function stop_spawning()
    enabled = false
end

function is_spawning()
    return enabled
end

function spawn()
    local customer = create_entity("customer")

    local transform = customer:add_transform()
    transform.position = vector3.new(
        entity:get_transform().position.x - waiting * 16,
        entity:get_transform().position.y,
        entity:get_transform().position.z)


    local sprite = customer:add_sprite()
    sprite.texture = texture.new("sprites/player.png")
    sprite.dimensions = vector2.new(16, 15)

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
    waiting = waiting + 1
    table.insert(waiting_customers, customer)
end

function take_customer()
    if waiting > 0 then
        table.remove(waiting_customers, 1)

        waiting = waiting - 1
        if waiting == 0 then
            find_entity("img_entry_attention"):get_scripts():get_script_env("ui_popup.lua").hide()
        end

        routine.create(function()
            routine.wait_seconds_func(0.5, function(x)
                for i=1, waiting do
                    local customer = waiting_customers[i]
                    local x_pos = entity:get_transform().position.x - ((i) * 16)
                    local customer_trans = customer:get_transform()
                    customer_trans.position = vector3.new(
                        lerp(x_pos, x_pos + 16, x),
                        customer_trans.position.y,
                        customer_trans.position.z
                    )
                    customer:update_transform()
                end
            end)
        end)
    end
end