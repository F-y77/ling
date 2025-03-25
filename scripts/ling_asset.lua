local itemtable = {
    "ling_backpack",
}

local tab = {}
for k, v in pairs(itemtable) do
    table.insert(Assets, Asset("ATLAS", "images/inventoryimages/" .. v .. ".xml"))
    table.insert(Assets, Asset("IMAGE", "images/inventoryimages/" .. v .. ".tex"))
    table.insert(Assets, Asset("ATLAS_BUILD", "images/inventoryimages/" .. v .. ".xml", 256))
    RegisterInventoryItemAtlas("images/inventoryimages/" .. v .. ".xml", v .. ".tex")

    tab[v] = resolvefilepath_soft("images/inventoryimages/" .. v .. ".xml")
end

-- 修改绘图工具组件，确保使用正确的图集
local DrawingTool = require("components/drawingtool")
local oldGetImageToDraw = DrawingTool.GetImageToDraw
function DrawingTool:GetImageToDraw(target)
    local image, ent, atlas, bgimage, bgatlas = oldGetImageToDraw(self, target)
    if image and tab[image] then
        atlas = tab[image]
    end
    return image, ent, atlas, bgimage, bgatlas
end 