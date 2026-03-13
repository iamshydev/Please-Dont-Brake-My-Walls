WaveManager = {}
WaveManager.__index = WaveManager

function WaveManager:new(waveData, spawn)
    self = setmetatable({
        waves = waveData,
        spawn = spawn,
        currentWave = 0,
        state = "waiting",
        waitTimer = 5.0,
        spawnQueue = {},
        spawnTimer = 0,
    }, WaveManager)
    return self
end

setmetatable(WaveManager, { __call = WaveManager.new })

function WaveManager:buildQueue(wave)
    local queue = {}
    for _, group in ipairs(wave.enemies) do
        for i = 1, group.count do
            table.insert(queue, { type = group.type, interval = group.interval })
        end
    end
    return queue
end

function WaveManager:update(dt)
    if self.state == "waiting" then
        self.waitTimer = self.waitTimer - dt
        if self.waitTimer <= 0 then
            self:startNextWave()
        end

    elseif self.state == "spawning" then
        self.spawnTimer = self.spawnTimer - dt
        if self.spawnTimer <= 0 and #self.spawnQueue > 0 then
            local next = table.remove(self.spawnQueue, 1)
            EnemyManager:spawnEnemy(self.spawn.x, self.spawn.y, next.type)
            self.spawnTimer = next.interval
        end

        if #self.spawnQueue == 0 and #EnemyManager.enemies == 0 then
            if self.currentWave >= #self.waves then
                self.state = "complete"
            else
                self.state = "waiting"
                self.waitTimer = 10.0
            end
        end
    end
end

function WaveManager:startNextWave()
    self.currentWave = self.currentWave + 1
    if self.currentWave > #self.waves then return end
    self.spawnQueue = self:buildQueue(self.waves[self.currentWave])
    self.spawnTimer = 0
    self.state = "spawning"
end

function WaveManager:getStatusText()
    if self.state == "waiting" then
        return ("Wave %d starting in %ds"):format(
            self.currentWave + 1, math.ceil(self.waitTimer))
    elseif self.state == "spawning" then
        return ("Wave %d"):format(self.currentWave)
    else
        return "You win!"
    end
end