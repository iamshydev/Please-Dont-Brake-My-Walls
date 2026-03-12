Player = {}
Player.__index = Player

function Player:new(health)
    local self = setmetatable({
        health = health
    }, Player)

    return self
end

setmetatable(Player, {
    __call = Player.new
})

function Player:takeDamage(damage)
    if self.health - damage <= 0 then
        self.health = 0
    else
        self.health = self.health - damage
    end
end