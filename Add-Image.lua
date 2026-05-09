local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local fileName = "Diederich_Image.gif"
local imageUrl = "https://github.com/kanargo/AvatarImage_Change/blob/main/Diederich_Image.gif"
local myUserIdStr = tostring(localPlayer.UserId)

if not isfile(fileName) then
    local success, content = pcall(function()
        return game:HttpGet(imageUrl)
    end)
    if success then
        writefile(fileName, content)
    end
end

local customAsset = getcustomasset(fileName)

local function applyGif(instance)
    if instance:IsA("ImageLabel") then
        if string.find(instance.Image, "rbxthumb") and string.find(instance.Image, myUserIdStr) then
            instance.Image = customAsset
        end
    end
end

local function scanAll()
    for _, v in pairs(game:GetDescendants()) do
        pcall(applyGif, v)
    end
end

game.DescendantAdded:Connect(function(descendant)
    pcall(applyGif, descendant)
    if descendant:IsA("ImageLabel") then
        descendant:GetPropertyChangedSignal("Image"):Connect(function()
            pcall(applyGif, descendant)
        end)
    end
end)

scanAll()
