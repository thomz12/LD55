scroll_speed = 1.0

function update(delta_time)
    local transform = entity:get_transform()
    transform.position = vector3.new(
        (transform.position.x + scroll_speed * delta_time) % 16, 
        (transform.position.y + scroll_speed * delta_time) % 16, 
        transform.position.z)
end