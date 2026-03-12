require "src.towers.Tower"

TowerManager = {}
TowerManager.__index = TowerManager

function TowerManager:new()
    local self = setmetatable({
        towers = {}
    }, TowerManager)

    return self
end

setmetatable(TowerManager, {
    __call = TowerManager.new
})

function TowerManager:spawnTower(x, y)
    local tower = Tower(x, y, 10, 36, 1, 0, 10, 10)
    table.insert(TowerManager.towers, tower)
end

function TowerManager:update(dt)
    for _, tower in ipairs(self.towers) do
        tower:update(dt)
    end
end

function TowerManager:draw()
    for _, tower in ipairs(self.towers) do
        tower:draw()
    end
end