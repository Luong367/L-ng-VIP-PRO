-- ==========================================
-- SCRIPT LƯƠNG VIP PRO (BẢN FIX LỖI ESP & TỐI ƯU)
-- ==========================================

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local cam = Workspace.CurrentCamera

-- Biến lưu trạng thái các tính năng
_G.LuongVIPPRO = _G.LuongVIPPRO or {
    noclip = false, flyOn = false, loopFB = false, infJ = false,
    pESP_Outline = false, pESP_HPBar = false, pESP_HPText = false, pESP_Name = false,
    flySpd = 60, jumpEn = false, jumpPower = 50,
    hitboxOn = false, hitboxSize = 2, mESP = false,
    speedEnabled = false, speedValue = 16, instantInteractEnabled = true
}

local state = _G.LuongVIPPRO

-- --- PHẦN 1: GIAO DIỆN CHÍNH ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LuongVIPPRO_Master_GUI"
screenGui.ResetOnSpawn = false
pcall(function()
    screenGui.Parent = game:GetService("CoreGui")
end)
if not screenGui.Parent then
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
end

local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
toggleButton.Image = "rbxassetid://17234938686"
toggleButton.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = toggleButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(0, 255, 200)
btnStroke.Thickness = 2
btnStroke.Parent = toggleButton

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 310)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.Visible = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(50, 50, 75)
frameStroke.Thickness = 1.5
frameStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
titleLabel.TextSize = 12
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "LƯƠNG VIP PRO - MASTER MENU (FIXED ESP)"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

local tabListFrame = Instance.new("ScrollingFrame")
tabListFrame.Size = UDim2.new(0, 110, 1, -40)
tabListFrame.Position = UDim2.new(0, 5, 0, 35)
tabListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
tabListFrame.BorderSizePixel = 0
tabListFrame.CanvasSize = UDim2.new(0, 0, 0, 250)
tabListFrame.ScrollBarThickness = 2
tabListFrame.Parent = mainFrame

local tabListCorner = Instance.new("UICorner")
tabListCorner.CornerRadius = UDim.new(0, 6)
tabListCorner.Parent = tabListFrame

local tabUIList = Instance.new("UIListLayout")
tabUIList.SortOrder = Enum.SortOrder.LayoutOrder
tabUIList.Padding = UDim.new(0, 5)
tabUIList.Parent = tabListFrame

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -125, 1, -40)
contentArea.Position = UDim2.new(0, 120, 0, 35)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local menuOpened = true
toggleButton.MouseButton1Click:Connect(function()
    menuOpened = not menuOpened
    mainFrame.Visible = menuOpened
end)

local dragging, dragStart, startPos
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local activeTabContent = nil
local activeTabButton = nil

local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -6, 0, 30)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Text = name
    tabBtn.Parent = tabListFrame

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 4)
    tbCorner.Parent = tabBtn

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 3
    tabContent.Visible = false
    tabContent.Parent = contentArea

    local tcLayout = Instance.new("UIListLayout")
    tcLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tcLayout.Padding = UDim.new(0, 6)
    tcLayout.Parent = tabContent

    tcLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, tcLayout.AbsoluteContentSize.Y + 10)
    end)

    tabBtn.MouseButton1Click:Connect(function()
        if activeTabContent then activeTabContent.Visible = false end
        if activeTabButton then 
            activeTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            activeTabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        tabBtn.TextColor3 = Color3.fromRGB(15, 15, 22)
        activeTabContent = tabContent
        activeTabButton = tabBtn
    end)

    if not activeTabContent then
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        tabBtn.TextColor3 = Color3.fromRGB(15, 15, 22)
        activeTabContent = tabContent
        activeTabButton = tabBtn
    end

    return tabContent
end

local function addToggle(tab, name, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 33)
    frame.Parent = tab

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.Position = UDim2.new(0, 5, 0, 5)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(50, 180, 80) or Color3.fromRGB(180, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = name .. (defaultState and ": BẬT" or ": TẮT")
    btn.Parent = frame

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = btn

    local st = defaultState
    btn.MouseButton1Click:Connect(function()
        st = not st
        btn.BackgroundColor3 = st and Color3.fromRGB(50, 180, 80) or Color3.fromRGB(180, 50, 50)
        btn.Text = name .. (st and ": BẬT" or ": TẮT")
        callback(st)
    end)
end

local function addInput(tab, name, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 33)
    frame.Parent = tab

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, -10, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = name
    label.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.4, -10, 0, 25)
    textBox.Position = UDim2.new(0.6, 0, 0, 5)
    textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    textBox.TextColor3 = Color3.fromRGB(0, 255, 200)
    textBox.TextSize = 11
    textBox.Font = Enum.Font.GothamBold
    textBox.Text = tostring(defaultVal)
    textBox.Parent = frame

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 4)
    tbCorner.Parent = textBox

    textBox.FocusLost:Connect(function()
        local num = tonumber(textBox.Text)
        if num then
            callback(num)
        else
            textBox.Text = tostring(defaultVal)
            callback(defaultVal)
        end
    end)
end

local tabInteract = createTab("Tiện ích")
addToggle(tabInteract, "Nhặt Đồ Nhanh", true, function(v) state.instantInteractEnabled = v end)

local tabHitbox = createTab("Hitbox")
addToggle(tabHitbox, "Bật Hitbox Extender", false, function(v) state.hitboxOn = v end)
addInput(tabHitbox, "Kích thước Hitbox", 2, function(v) state.hitboxSize = v end)

local tabMove = createTab("Di chuyển")
addToggle(tabMove, "Tăng Tốc Chạy", false, function(v) state.speedEnabled = v end)
addInput(tabMove, "Tốc độ (Speed)", 16, function(v) state.speedValue = v end)
addToggle(tabMove, "Bay (Fly)", false, function(v) state.flyOn = v end)
addInput(tabMove, "Tốc độ bay", 60, function(v) state.flySpd = v end)
addToggle(tabMove, "Nhảy Cao", false, function(v) state.jumpEn = v end)
addInput(tabMove, "Sức nhảy", 50, function(v) state.jumpPower = v end)
addToggle(tabMove, "Nhảy Vô Hạn", false, function(v) state.infJ = v end)
addToggle(tabMove, "Xuyên Tường", false, function(v) state.noclip = v end)

local tabVisual = createTab("Visual")
addToggle(tabVisual, "ESP Viền Player", false, function(v) state.pESP_Outline = v end)
addToggle(tabVisual, "ESP Thanh Máu", false, function(v) state.pESP_HPBar = v end)
addToggle(tabVisual, "ESP Số Máu", false, function(v) state.pESP_HPText = v end)
addToggle(tabVisual, "ESP Tên Player", false, function(v) state.pESP_Name = v end)
addToggle(tabVisual, "ESP Quái Vật", false, function(v) state.mESP = v end)
addToggle(tabVisual, "LoopFB & NoFog", false, function(v) state.loopFB = v end)


-- --- PHẦN 2: HỆ THỐNG ESP ĐÃ FIX CHUẨN XÁC ---
local espCache = {}

local function removeESP(char)
    if espCache[char] then
        pcall(function()
            if espCache[char].hl then espCache[char].hl:Destroy() end
            if espCache[char].bg then espCache[char].bg:Destroy() end
        end)
        espCache[char] = nil
    end
end

local function setupPlayerESP(player)
    if player == localPlayer then return end
    
    player.CharacterAdded:Connect(function(char)
        removeESP(char)
        task.wait(1) -- Chờ load xong nhân vật
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        
        local hl = Instance.new("Highlight", char)
        hl.Name = "HML_Highlight"
        hl.FillTransparency = 1
        hl.OutlineColor = Color3.fromRGB(0, 255, 255)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = false
        
        local bg = Instance.new("BillboardGui", head)
        bg.Name = "HML_Billboard"
        bg.Size = UDim2.new(0, 150, 0, 50)
        bg.StudsOffset = Vector3.new(0, 3, 0)
        bg.AlwaysOnTop = true
        bg.Enabled = false
        
        local nameLab = Instance.new("TextLabel", bg)
        nameLab.Size = UDim2.new(1, 0, 0.4, 0)
        nameLab.BackgroundTransparency = 1
        nameLab.Text = player.Name
        nameLab.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLab.TextScaled = true
        nameLab.Font = Enum.Font.GothamBold
        nameLab.Visible = false
        
        local hpLab = Instance.new("TextLabel", bg)
        hpLab.Size = UDim2.new(1, 0, 0.4, 0)
        hpLab.Position = UDim2.new(0, 0, 0.4, 0)
        hpLab.BackgroundTransparency = 1
        hpLab.TextColor3 = Color3.fromRGB(0, 255, 0)
        hpLab.TextScaled = true
        hpLab.Font = Enum.Font.GothamBold
        hpLab.Visible = false
        
        local barBg = Instance.new("Frame", bg)
        barBg.Size = UDim2.new(0.8, 0, 0.15, 0)
        barBg.Position = UDim2.new(0.1, 0, 0.85, 0)
        barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        barBg.BorderSizePixel = 0
        barBg.Visible = false
        
        local barFill = Instance.new("Frame", barBg)
        barFill.Size = UDim2.new(1, 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        barFill.BorderSizePixel = 0
        
        espCache[char] = {hl = hl, bg = bg, name = nameLab, hpText = hpLab, barBg = barBg, barFill = barFill, head = head, char = char}
    end)
    
    if player.Character then
        local char = player.Character
        task.spawn(function()
            local head = char:WaitForChild("Head", 5)
            if head then
                local hl = Instance.new("Highlight", char)
                hl.Name = "HML_Highlight"
                hl.FillTransparency = 1
                hl.OutlineColor = Color3.fromRGB(0, 255, 255)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Enabled = false
                
                local bg = Instance.new("BillboardGui", head)
                bg.Name = "HML_Billboard"
                bg.Size = UDim2.new(0, 150, 0, 50)
                bg.StudsOffset = Vector3.new(0, 3, 0)
                bg.AlwaysOnTop = true
                bg.Enabled = false
                
                local nameLab = Instance.new("TextLabel", bg)
                nameLab.Size = UDim2.new(1, 0, 0.4, 0)
                nameLab.BackgroundTransparency = 1
                nameLab.Text = player.Name
                nameLab.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLab.TextScaled = true
                nameLab.Font = Enum.Font.GothamBold
                nameLab.Visible = false
                
                local hpLab = Instance.new("TextLabel", bg)
                hpLab.Size = UDim2.new(1, 0, 0.4, 0)
                hpLab.Position = UDim2.new(0, 0, 0.4, 0)
                hpLab.BackgroundTransparency = 1
                hpLab.TextColor3 = Color3.fromRGB(0, 255, 0)
                hpLab.TextScaled = true
                hpLab.Font = Enum.Font.GothamBold
                hpLab.Visible = false
                
                local barBg = Instance.new("Frame", bg)
                barBg.Size = UDim2.new(0.8, 0, 0.15, 0)
                barBg.Position = UDim2.new(0.1, 0, 0.85, 0)
                barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                barBg.BorderSizePixel = 0
                barBg.Visible = false
                
                local barFill = Instance.new("Frame", barBg)
                barFill.Size = UDim2.new(1, 0, 1, 0)
                barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                barFill.BorderSizePixel = 0
                
                espCache[char] = {hl = hl, bg = bg, name = nameLab, hpText = hpLab, barBg = barBg, barFill = barFill, head = head, char = char}
            end
        end)
    end
end

for _, p in pairs(Players:GetPlayers()) do
    setupPlayerESP(p)
end
Players.PlayerAdded:Connect(setupPlayerESP)
Players.PlayerRemoving:Connect(function(p)
    if p.Character then removeESP(p.Character) end
end)

-- Vòng lặp RenderStepped mượt mà cập nhật ESP theo thời gian thực
RunService.RenderStepped:Connect(function()
    for char, data in pairs(espCache) do
        if not char or not char.Parent or not data.head or not data.head.Parent then
            removeESP(char)
        else
            local anyESP = state.pESP_Outline or state.pESP_Name or state.pESP_HPText or state.pESP_HPBar
            if anyESP then
                data.bg.Enabled = true
                data.hl.Enabled = state.pESP_Outline
                data.name.Visible = state.pESP_Name
                data.hpText.Visible = state.pESP_HPText
                data.barBg.Visible = state.pESP_HPBar
                
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    local hp = math.clamp(hum.Health, 0, hum.MaxHealth)
                    local maxHp = hum.MaxHealth
                    local ratio = maxHp > 0 and (hp / maxHp) or 0
                    data.hpText.Text = "HP: " .. math.floor(hp) .. " / " .. math.floor(maxHp)
                    data.barFill.Size = UDim2.new(ratio, 0, 1, 0)
                end
            else
                data.bg.Enabled = false
                data.hl.Enabled = false
            end
        end
    end
    
    -- Xử lý vòng lặp tính năng bay, nhảy, noclip và hitbox
    local char = localPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if state.jumpEn and hum then 
            hum.UseJumpPower = true 
            hum.JumpPower = state.jumpPower 
        end
        if state.noclip then 
            for _,v in pairs(char:GetDescendants()) do 
                if v:IsA("BasePart") then v.CanCollide = false end 
            end 
        end
    end
    
    if state.hitboxOn then 
        for _, v in pairs(Players:GetPlayers()) do 
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then 
                v.Character.HumanoidRootPart.Size = Vector3.new(state.hitboxSize, state.hitboxSize, state.hitboxSize) 
                v.Character.HumanoidRootPart.Transparency = 0.7 
            end 
        end 
    end
end)

-- Vòng lặp xử lý tốc độ di chuyển
task.spawn(function()
    while true do
        if state.speedEnabled and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = state.speedValue
        end
        task.wait(0.5)
    end
end)

-- Vòng lặp ESP Quái vật tối ưu
task.spawn(function()
    while true do
        if state.mESP then
            pcall(function()
                for _, m in pairs(Workspace:GetChildren()) do
                    if m:IsA("Model") and m:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(m) then
                        local mNameLower = m.Name:lower()
                        if mNameLower:find("wolf") or mNameLower:find("wendigo") or mNameLower:find("stalker") or mNameLower:find("beast") then
                            if not m:FindFirstChild("HML_MonsterHighlight") then
                                local h = Instance.new("Highlight", m)
                                h.Name = "HML_MonsterHighlight"; h.OutlineColor = Color3.fromRGB(255, 0, 0); h.FillTransparency = 1; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            end
                            if not m:FindFirstChild("HML_MonsterESP") then
                                local root = m:FindFirstChild("Head") or m.PrimaryPart
                                if root then
                                    local bg = Instance.new("BillboardGui", root)
                                    bg.Name, bg.Size, bg.AlwaysOnTop = "HML_MonsterESP", UDim2.new(0,150,0,40), true
                                    local tl = Instance.new("TextLabel", bg)
                                    tl.BackgroundTransparency = 1; tl.Size = UDim2.new(1,0,1,0); tl.Text = "Quái Vật"
                                    tl.TextColor3 = Color3.fromRGB(255, 
