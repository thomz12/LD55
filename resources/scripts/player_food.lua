local orders = 0
local carrying = 0

function get_order()
    if carrying > 0 then
        carrying = carrying - 1
        return true
    end
    return false
end

function add_order()
    orders = orders + 1
end

function on_contact(this, other)
    if other.name == "kitchen" then
        carrying = carrying + orders
        orders = 0
    end
end