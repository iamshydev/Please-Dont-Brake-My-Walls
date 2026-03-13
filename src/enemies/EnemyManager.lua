local EnemyTypes = require "src.enemies.EnemyTypes"
require "src.enemies.Enemy"

EnemyManager = {}
EnemyManager.__index = EnemyManager

function EnemyManager:new(path)
    self = setmetatable({
        enemies = {},
        path = path
    }, EnemyManager)

    return self
end

setmetatable(EnemyManager, {
    __call = EnemyManager.new
})

function EnemyManager:spawnEnemy(x, y, enemyType)
    local def = EnemyTypes[enemyType or "basic"]
    local enemy = Enemy(x, y, 1, def.maxHealth, def.maxHealth, def.speed, def.damage, def.width, def.height, def.gold, def.color)
    table.insert(self.enemies, enemy)
end

function EnemyManager:update(dt)
    for i = #self.enemies, 1, -1 do
        local alive = self.enemies[i]:update(dt, self.path)
        if not alive then
            if self.enemies[i].health <= 0 then
                Player:earnGold(self.enemies[i].gold)
            end
            table.remove(self.enemies, i)
        end
    end
end

function EnemyManager:draw()
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end
end