Tower = {}
Tower.__index = Tower

function Tower:new(x, y, damage, range, fireRate, cooldown, width, height, cost)
    local self = setmetatable({
        x = x,
        y = y,
        damage = damage,
        range = range,
        fireRate = fireRate,
        cooldown = cooldown,
        width = width,
        height = height,
        cost = cost
    }, Tower)

    return self
end

setmetatable(Tower, {
    __call = Tower.new
})

function Tower:update(dt)
    self.cooldown = self.cooldown - dt
    if self.cooldown <= 0 then
        for _, enemy in ipairs(EnemyManager.enemies) do
            local dx = enemy.x - self.x
            local dy = enemy.y - self.y
            local dist = math.sqrt(dx*dx + dy*dy)

            if dist <= self.range then
                enemy.health = enemy.health - self.damage
                self.cooldown = 1 / self.fireRate
                break
            end
        end
    end
end

function Tower:draw()
    love.graphics.setColor(1,1,0)
    love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)

    if Game.debug then
        love.graphics.setColor(1,1,0)
        love.graphics.circle("line", self.x, self.y, self.range)
    end

    love.graphics.setColor(1,1,1)
end