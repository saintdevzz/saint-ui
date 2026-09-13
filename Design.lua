local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("StarterGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0.00, 639.00, 0.00, 441.00)
Main.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
Main.Position = UDim2.new(0.24, 0.00, 0.21, 0.00)
Main.BorderSizePixel = 0
Main.BackgroundColor3 = Color3.new(0.04, 0.04, 0.04)
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.00, 6.00)
UICorner.Parent = Main

local Button = Instance.new("TextButton")
Button.Name = "Button"
Button.BorderSizePixel = 0
Button.BackgroundColor3 = Color3.new(0.93, 0.93, 0.93)
Button.FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Button.TextSize = 15
Button.Size = UDim2.new(0.00, 127.00, 0.00, 35.00)
Button.TextColor3 = Color3.new(0.00, 0.00, 0.00)
Button.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
Button.Position = UDim2.new(0.30, 0.00, 0.83, 0.00)
Button.Parent = Main

local UICorner_1 = Instance.new("UICorner")
UICorner_1.CornerRadius = UDim.new(0.00, 32.00)
UICorner_1.Parent = Button

local Button_Outlined = Instance.new("TextButton")
Button_Outlined.Name = "Button Outlined"
Button_Outlined.BorderSizePixel = 0
Button_Outlined.BackgroundColor3 = Color3.new(0.04, 0.04, 0.04)
Button_Outlined.FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Button_Outlined.TextSize = 15
Button_Outlined.Size = UDim2.new(0.00, 127.00, 0.00, 35.00)
Button_Outlined.TextColor3 = Color3.new(1.00, 1.00, 1.00)
Button_Outlined.BorderColor3 = Color3.new(1.00, 1.00, 1.00)
Button_Outlined.Position = UDim2.new(0.53, 0.00, 0.83, 0.00)
Button_Outlined.Parent = Main

local UICorner_1 = Instance.new("UICorner")
UICorner_1.CornerRadius = UDim.new(0.00, 32.00)
UICorner_1.Parent = Button_Outlined

local UIStroke = Instance.new("UIStroke")
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.new(0.71, 0.71, 0.71)
UIStroke.Parent = Button_Outlined

local Slider = Instance.new("Frame")
Slider.Name = "Slider"
Slider.Size = UDim2.new(0.00, 269.00, 0.00, 4.00)
Slider.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
Slider.Position = UDim2.new(0.30, 0.00, 0.67, 0.00)
Slider.BorderSizePixel = 0
Slider.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
Slider.Parent = Main

local UICorner_1 = Instance.new("UICorner")
UICorner_1.Parent = Slider

local Slider_itself__the_button_ = Instance.new("TextButton")
Slider_itself__the_button_.Name = "Slider itself (the button)"
Slider_itself__the_button_.BorderSizePixel = 0
Slider_itself__the_button_.BackgroundColor3 = Color3.new(1.00, 1.00, 1.00)
Slider_itself__the_button_.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Slider_itself__the_button_.TextSize = 14
Slider_itself__the_button_.Size = UDim2.new(0.00, 18.00, 0.00, 18.00)
Slider_itself__the_button_.TextColor3 = Color3.new(0.00, 0.00, 0.00)
Slider_itself__the_button_.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
Slider_itself__the_button_.Text = ""
Slider_itself__the_button_.Position = UDim2.new(0.38, 0.00, -1.75, 0.00)
Slider_itself__the_button_.Parent = Slider

local UICorner_1 = Instance.new("UICorner")
UICorner_1.CornerRadius = UDim.new(0.00, 32.00)
UICorner_1.Parent = Slider_itself__the_button_

local Titlebar = Instance.new("Frame")
Titlebar.Name = "Titlebar"
Titlebar.Size = UDim2.new(0.00, 639.00, 0.00, 58.00)
Titlebar.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
Titlebar.BorderSizePixel = 0
Titlebar.BackgroundTransparency = 1
Titlebar.BackgroundColor3 = Color3.new(1.00, 1.00, 1.00)
Titlebar.Parent = Main

local Seprator = Instance.new("Frame")
Seprator.Name = "Seprator"
Seprator.Size = UDim2.new(0.00, 639.00, 0.00, -1.00)
Seprator.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
Seprator.Position = UDim2.new(0.00, 0.00, 0.87, 0.00)
Seprator.BorderSizePixel = 0
Seprator.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
Seprator.Parent = Titlebar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BorderSizePixel = 0
Title.BackgroundColor3 = Color3.new(1.00, 1.00, 1.00)
Title.FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Title.TextSize = 16
Title.Size = UDim2.new(0.00, 64.00, 0.00, 26.00)
Title.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
Title.Text = "Saint"
Title.TextColor3 = Color3.new(1.00, 1.00, 1.00)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.01, 0.00, 0.19, 0.00)
Title.Parent = Titlebar

local Title_1 = Instance.new("TextLabel")
Title_1.Name = "Title"
Title_1.BorderSizePixel = 0
Title_1.BackgroundColor3 = Color3.new(1.00, 1.00, 1.00)
Title_1.FontFace = Font.new("rbxassetid://16658237174", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Title_1.TextSize = 12
Title_1.Size = UDim2.new(0.00, 64.00, 0.00, 32.00)
Title_1.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
Title_1.Text = "v0.0.1"
Title_1.TextColor3 = Color3.new(0.85, 0.85, 0.85)
Title_1.BackgroundTransparency = 1
Title_1.Position = UDim2.new(0.51, 0.00, 0.00, 0.00)
Title_1.Parent = Title

local WindowControlsHolder = Instance.new("Frame")
WindowControlsHolder.Name = "WindowControlsHolder"
WindowControlsHolder.Size = UDim2.new(0.00, 58.00, 0.00, 26.00)
WindowControlsHolder.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
WindowControlsHolder.Position = UDim2.new(0.88, 0.00, 0.19, 0.00)
WindowControlsHolder.BorderSizePixel = 0
WindowControlsHolder.BackgroundColor3 = Color3.new(0.06, 0.06, 0.06)
WindowControlsHolder.Parent = Titlebar

local UICorner_1 = Instance.new("UICorner")
UICorner_1.CornerRadius = UDim.new(0.00, 6.00)
UICorner_1.Parent = WindowControlsHolder

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.BorderSizePixel = 0
Close.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
Close.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Close.TextSize = 14
Close.Size = UDim2.new(0.00, 21.00, 0.00, 20.00)
Close.TextColor3 = Color3.new(1.00, 1.00, 1.00)
Close.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
Close.Text = "X"
Close.Position = UDim2.new(0.55, 0.00, 0.12, 0.00)
Close.Parent = WindowControlsHolder

local UICorner_1 = Instance.new("UICorner")
UICorner_1.CornerRadius = UDim.new(0.00, 5.00)
UICorner_1.Parent = Close

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.TextWrapped = true
Minimize.BorderSizePixel = 0
Minimize.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
Minimize.FontFace = Font.new("rbxassetid://12188570269", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
Minimize.TextSize = 14
Minimize.Size = UDim2.new(0.00, 21.00, 0.00, 20.00)
Minimize.TextColor3 = Color3.new(1.00, 1.00, 1.00)
Minimize.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
Minimize.Text = "-"
Minimize.Position = UDim2.new(0.08, 0.00, 0.12, 0.00)
Minimize.Parent = WindowControlsHolder

local UICorner_1 = Instance.new("UICorner")
UICorner_1.CornerRadius = UDim.new(0.00, 5.00)
UICorner_1.Parent = Minimize

local nav = Instance.new("Frame")
nav.Name = "nav"
nav.Size = UDim2.new(0.00, 165.00, 0.00, 35.00)
nav.BorderColor3 = Color3.new(0.00, 0.00, 0.00)
nav.Position = UDim2.new(0.37, 0.00, 0.11, 0.00)
nav.BorderSizePixel = 0
nav.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
nav.Parent = Main

local UICorner_1 = Instance.new("UICorner")
UICorner_1.CornerRadius = UDim.new(0.00, -8.00)
UICorner_1.Parent = nav

