local Player = game.Players.LocalPlayer
local InputService = game:GetService("UserInputService")

local UI_Library = {}
UI_Library.__index = UI_Library

-- Configurações da UI
UI_Library.FCgf = {
    BackSize = UDim2.new(0.27775, 0, 0.5555, 0),
    MenuSize = UDim2.new(0.97722, 0, 0.97722, 0),
    CornerRadius = UDim.new(0.004, 0),
    Colors = {
        Background = Color3.fromRGB(50, 50, 50),
        Frame = Color3.fromRGB(20, 20, 20),
        GradientStart = Color3.fromRGB(120, 160, 255),
        GradientEnd = Color3.fromRGB(144, 238, 144)
    }
}

-- Função para criar um novo UI Elemento
function UI_Library:createUIElement(class, properties, parent)
    local element = Instance.new(class)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    element.Parent = parent
    return element
end

-- Cria uma nova janela
function UI_Library:createWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")

    -- Cria o Frame de fundo
    local BackG = self:createUIElement("Frame", {
        Size = self.FCgf.BackSize,
        Position = UDim2.new(0.5 - self.FCgf.BackSize.X.Scale / 2, 0, 0.5 - self.FCgf.BackSize.Y.Scale / 2, 0),
        BackgroundColor3 = self.FCgf.Colors.Background
    }, ScreenGui)

    -- Frame principal com contorno e arredondamento
    local Frame = self:createUIElement("Frame", {
        Size = self.FCgf.MenuSize,
        Position = UDim2.new(0.5 - self.FCgf.MenuSize.X.Scale / 2, 0, 0.5 - self.FCgf.MenuSize.Y.Scale / 2, 0),
        BackgroundColor3 = self.FCgf.Colors.Frame
    }, BackG)
    self:createUIElement("UICorner", { CornerRadius = self.FCgf.CornerRadius }, Frame)
    self:createUIElement("UIStroke", {}, Frame)

    -- Frame de gradiente com transição de cor
    local GradientFrame = self:createUIElement("Frame", {
        Size = UDim2.new(1, 0.5, 0.002, 0),
        Position = UDim2.new(0.00125, 0, 0.0045, 0),
        BackgroundColor3 = Color3.new(1, 1, 1)
    }, Frame)
    self:createUIElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.FCgf.Colors.GradientStart),
            ColorSequenceKeypoint.new(1, self.FCgf.Colors.GradientEnd)
        })
    }, GradientFrame)

    -- Funções de movimentação
    local isDragging, dragStart, startPos = false

    local function onMouseDown(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            startPos = BackG.Position
        end
    end

    local function onMouseMove(input)
        if isDragging then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
            local newPositionX = startPos.X.Offset + delta.X
            local newPositionY = startPos.Y.Offset + delta.Y

            -- Limites da tela
            local screenWidth = workspace.CurrentCamera.ViewportSize.X
            local screenHeight = workspace.CurrentCamera.ViewportSize.Y
            local backGWidth = BackG.AbsoluteSize.X
            local backGHeight = BackG.AbsoluteSize.Y

            -- Calcula as novas posições com limites
            newPositionX = math.clamp(newPositionX, 0, screenWidth - backGWidth)
            newPositionY = math.clamp(newPositionY, 0, screenHeight - backGHeight)

            -- Atualiza a posição do BackG usando apenas Offset
            BackG.Position = UDim2.new(0, newPositionX, 0, newPositionY)
        end
    end

    local function onMouseUp(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end

    -- Conectar eventos de mouse ao BackG
    BackG.InputBegan:Connect(onMouseDown)
    InputService.InputEnded:Connect(onMouseUp)
    InputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            onMouseMove(input)
        end
    end)

    return Frame
end

-- Cria um botão na janela
function UI_Library:createButton(window, text, callback)
    local Button = self:createUIElement("TextButton", {
        Size = UDim2.new(0.5, 0, 0.1, 0),
        Position = UDim2.new(0.25, 0, 0.1, 0),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        Text = text,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 24,
        AutoButtonColor = false,
        Parent = window
    })

    Button.MouseButton1Click:Connect(function()
        callback()
    end)

    return Button
end

-- Retorna a biblioteca
return UI_Library
