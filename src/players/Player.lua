Player = {}
Player.__index = Player

function Player:new(maxHealth, health, gold)
    local self = setmetatable({
        maxHealth = maxHealth,
        health = health,
        gold = gold
    }, Player)

    return self
end

setmetatable(Player, {
    __call = Player.new
})

function Player:earnGold(amount)
    self.gold = self.gold + amount
end

function Player:spendGold(amount)
    if self.gold < amount then
        return false
    end
    self.gold = self.gold - amount
    return true
end

function Player:takeDamage(damage)
    if self.health - damage <= 0 then
        self.health = 0
    else
        self.health = self.health - damage
    end
end