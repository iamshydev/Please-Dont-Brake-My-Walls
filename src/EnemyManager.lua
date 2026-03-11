require "src.Enemy"

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

function EnemyManager:spawnEnemy(x, y)
    local enemy = Enemy(x, y, 2, 20, 20, 100, 2, 8, 8)
    table.insert(self.enemies, enemy)
end

function EnemyManager:update(dt)
    for i = #self.enemies, 1, -1 do
        local alive = self.enemies[i]:update(dt, self.path)
        if not alive then
            table.remove(self.enemies, i)
        end
    end
end

function EnemyManager:draw()
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end
end