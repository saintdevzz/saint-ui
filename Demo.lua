local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/saintdevzz/saint-ui/main/UILIB.lua"))()

local window = UILib:Window({
	title = "Saint",
	subtitle = "v0.0.1",
	nav = true,
	size = UDim2.fromOffset(639, 441),
	position = 0.5,
})

local home = window:Page("Home", "home")
local settings = window:Page("Settings", "settings")

home:Section("Buttons")
home:Label("Every component in this page is live, click around and see.")

home:Button({
	title = "Execute",
	callback = function()
		print("[Saint] Execute pressed")
	end,
})

home:Button({
	title = "Cancel",
	variant = "outlined",
	callback = function()
		print("[Saint] Cancel pressed")
	end,
})

local toggled = home:Button({
	title = "Toggle Me",
	callback = function() end,
})

local state = false
toggled:SetCallback(function()
	state = not state
	toggled:SetTitle(state and "Enabled" or "Toggle Me")
	print("[Saint] state is now", state)
end)

home:Section("Sliders")
home:Divider()

home:Slider({
	title = "WalkSpeed",
	min = 16,
	max = 200,
	value = 16,
	callback = function(value)
		local character = game:GetService("Players").LocalPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = value
		end
		print("[Saint] WalkSpeed", value)
	end,
})

home:Slider({
	title = "Transparency",
	min = 0,
	max = 1,
	decimals = 2,
	value = 0,
	suffix = "",
	callback = function(value)
		print("[Saint] Transparency", value)
	end,
})

home:Section("Keybinds")

home:Keybind({
	title = "Toggle Menu",
	key = Enum.KeyCode.RightShift,
	callback = function(key)
		print("[Saint] bound", key.Name)
	end,
})

home:Keybind({
	title = "Panic Key",
	callback = function(key)
		print("[Saint] panic bound to", key.Name)
	end,
})

settings:Section("Text Input")

local nameBox = settings:TextBox({
	placeholder = "Type your name...",
	callback = function(text, enterPressed)
		print("[Saint] text", text, "enter", enterPressed)
	end,
})

settings:Button({
	title = "Print Text Box Value",
	variant = "outlined",
	callback = function()
		print("[Saint] box contains", nameBox:GetText())
	end,
})

settings:Section("Options")
settings:Divider()

local mode = settings:Dropdown({
	options = { "Legit", "Rage", "Silent Aim", "Blatant", "Custom" },
	default = "Legit",
	placeholder = "Choose a mode...",
	callback = function(option)
		print("[Saint] mode", option)
	end,
})

settings:Dropdown({
	options = { "Low", "Medium", "High", "Ultra" },
	placeholder = "Pick a quality...",
	callback = function(option)
		print("[Saint] quality", option)
	end,
})

settings:Section("Toggles")

local infinite = settings:Toggle({
	title = "Infinite Jump",
	value = false,
	callback = function(value)
		print("[Saint] infinite jump", value)
	end,
})

settings:Toggle({
	title = "Fullbright",
	value = true,
	callback = function(value)
		local lighting = game:GetService("Lighting")
		lighting.Brightness = value and 3 or 2
		print("[Saint] fullbright", value)
	end,
})

settings:Slider({
	title = "Field Of View",
	min = 20,
	max = 120,
	value = 70,
	callback = function(value)
		local camera = workspace.CurrentCamera
		if camera then
			camera.FieldOfView = value
		end
		print("[Saint] fov", value)
	end,
})

settings:Keybind({
	title = "Middle Click",
	key = Enum.UserInputType.MouseButton2,
	callback = function(key)
		print("[Saint] bound", key.Name)
	end,
})

settings:Section("Actions")

settings:Button({
	title = "Reset Settings",
	variant = "outlined",
	callback = function()
		infinite:SetValue(false)
		mode:SetValue("Legit")
		nameBox:SetText("")
		print("[Saint] settings reset")
	end,
})

settings:Button({
	title = "Close Menu",
	callback = function()
		window:Close()
	end,
})

window:Select("Home")

print("[Saint] loaded")
