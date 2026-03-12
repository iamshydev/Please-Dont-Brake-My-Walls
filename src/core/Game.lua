local sti = require "libs.sti"
require "src.enemies.EnemyManager"
require "src.towers.TowerManager"
require "src.players.Player"

Game = {}
Game.__index = Game

function Game:new()
    local self = setmetatable({
        debug = false
    }, Game)

    return self
end

setmetatable(Game, {
    __call = Game.new
})

function Game:load()
    Map = sti("assets/tilemaps/plains.lua")

    local path = {}
    Spawn = {}

    for _, layer in ipairs(Map.layers) do
        if layer.name == "EnemyPath" then
            local obj = layer.objects[1]
            Spawn = { x = layer.objects[2].x, y = layer.objects[2].y }

            for _, point in ipairs(obj.polyline) do
                table.insert(path, { x = point.x, y = point.y })
            end
        end
    end

    Player = Player(100, 100, 100)
    EnemyManager = EnemyManager(path)
    TowerManager = TowerManager()
end

function Game:toggleDebug()
    self.debug = not self.debug
end

function Game:update(dt)
    EnemyManager:update(dt)
    TowerManager:update(dt)
end

function Game:mousepressed(x, y, button)
    if button == 1 then
        TowerManager:spawnTower(x, y)
    end
end

function Game:keypressed(key)
    if key == "return" then
        EnemyManager:spawnEnemy(Spawn.x, Spawn.y)
    end

    if key == "f3" then
        self:toggleDebug()
    end
end

function Game:draw()
    if self.debug then
        Map:draw()
    else
        for _, layer in ipairs(Map.layers) do
            if layer.type == "tilelayer" then
                layer:draw()
            end
        end
    end

    EnemyManager:draw()
    TowerManager:draw()

    love.graphics.print(("Health: %d/%d"):format(Player.health, Player.maxHealth), 300, 20)
    love.graphics.print(("Gold: %d"):format(Player.gold), 300, 40)
end