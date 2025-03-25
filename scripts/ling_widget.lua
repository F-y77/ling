local containers = require "containers"
local params = containers.params

-- 定义熊猫背包容器
params.ling_backpack = {
    widget = {
        slotpos = {},
        animbank = "ui_piggyback_2x6",
        animbuild = "ui_piggyback_2x6",
        --        pos = Vector3(-5, -50, 0),
        pos = Vector3(-5, -90, 0),
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1,
}

-- 设置背包格子位置 (2列6行，共12格)
for y = 0, 5 do
    table.insert(params.ling_backpack.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
    table.insert(params.ling_backpack.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
end

--------------------------------------------------------------------------

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

--------------------------------------------------------------------------
