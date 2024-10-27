-- UI_Lib ModuleScript
local UI_Lib = {}

-- Configuração inicial
local Player = game.Players.LocalPlayer
local InputService = game:GetService("UserInputService")
local Mouse = Player:GetMouse()

-- Função para criar uma nova janela
function UI_Lib:CreateWindow(size, position, title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    
    local window = Instance.new("Frame")
    window.Size = UDim2.new(size.X, 0, size.Y, 0)
    window.Position = UDim2.new(position.X, 0, position.Y, 0)
    window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    window.Parent = ScreenGui

    -- Adiciona título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title or "Window"
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.Parent = window
    
    -- Adiciona gradiente ao fundo
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 160, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(144, 238, 144))
    }
    gradient.Parent = window

    -- Função para arrastar a janela
    self:MakeDraggable(window)
    return window
end

-- Função para tornar a janela arrastável
function UI_Lib:MakeDraggable(frame)
    local isDragging = false
    local dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = Vector2.new(Mouse.X, Mouse.Y)
            startPos = frame.Position
        end
    end)
    
    InputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(Mouse.X, Mouse.Y) - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    InputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
end

-- Função para criar um botão
function UI_Lib:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Text = text or "Button"
    button.Size = UDim2.new(0.8, 0, 0.1, 0)
    button.Position = UDim2.new(0.1, 0, 0.15, 0)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.Parent = parent
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return button
end

return UI_Lib