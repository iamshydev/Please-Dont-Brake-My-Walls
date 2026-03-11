Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, target, maxHealth, health, speed, damage, width, height)
    self = setmetatable({
        x = x,
        y = y,
        target = target,
        maxHealth = maxHealth,
        health = health,
        speed = speed,
        damage = damage,
        width = width,
        height = height
    }, Enemy)

    return self
end

setmetatable(Enemy, {
    __call = Enemy.new
})

function Enemy:update(dt, path)
    if self.health <= 0 then
        return false
    end

    local targetPoint = path[self.target]
    if targetPoint then
        local dx = targetPoint.x - self.x
        local dy = targetPoint.y - self.y
        local dist = math.sqrt(dx*dx + dy*dy)

        if dist < 2 then
            self.target = self.target + 1
        else
            self.x = self.x + dx / dist * self.speed * dt
            self.y = self.y + dy / dist * self.speed * dt
        end
    else
        Health = Health - self.damage
        return false
    end

    return true
end

function Enemy:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)

    local hpPercent = self.health / self.maxHealth
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", self.x - 10, self.y - 12, 20 * hpPercent, 3)
    love.graphics.setColor(1,1,1)
end