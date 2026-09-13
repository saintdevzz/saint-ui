local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/saintdevzz/saint-ui/main/UILIB.lua?v=" .. os.time()))()

local window = UILib:Window({
	title = "Saint",
	subtitle = "v0.0.1",
	size = UDim2.fromOffset(720, 470),
	position = 0.5,
})

local home = window:Page("Home")
local combat = window:Page("Combat")
local settings = window:Page("Settings")

home:Group("Quick actions")
home:Label("Everything on this page is live, click around and see.")

home:Button({
	title = "Execute",
	button = "Run",
	desc = "Runs the selected script on your character",
	callback = function()
		print("[Saint] Execute pressed")
	end,
})

home:Button({
	title = "Cancel",
	button = "Abort",
	desc = "Stops whatever is running right now",
	callback = function()
		print("[Saint] Cancel pressed")
	end,
})

local swap
swap = home:Button({
	title = "Swap mode",
	button = "Client",
	callback = function()
		local target = swap:GetButton() == "Client" and "Server" or "Client"
		swap:SetButton(target)
		print("[Saint] Mode is now " .. target)
	end,
})

home:Divider()

local movement = home:Module({
	title = "Movement",
	desc = "Everything about how far and how fast you go",
})

movement:Toggle({
	title = "Sprint",
	value = true,
	callback = function(state)
		print("[Saint] Sprint " .. tostring(state))
	end,
})

movement:Slider({
	title = "WalkSpeed",
	min = 16,
	max = 500,
	value = 80,
	callback = function(number)
		print("[Saint] WalkSpeed " .. number)
	end,
})

movement:Dropdown({
	title = "Style",
	placeholder = "Pick a style",
	options = { "Normal", "Bypass", "Silent" },
	callback = function(option)
		print("[Saint] Style " .. tostring(option))
	end,
})

combat:Group("Aim")

combat:Toggle({
	title = "AimAssist",
	desc = "Pulls your crosshair toward the nearest target",
	value = true,
	callback = function(state)
		print("[Saint] AimAssist " .. tostring(state))
	end,
})

combat:Dropdown({
	title = "Target part",
	options = { "Head", "Torso", "Closest" },
	default = "Head",
	callback = function(option)
		print("[Saint] Target part " .. tostring(option))
	end,
})

combat:Slider({
	title = "FOV",
	min = 0,
	max = 360,
	value = 90,
	suffix = " deg",
	callback = function(number)
		print("[Saint] FOV " .. number)
	end,
})

local silent = combat:Module({
	title = "Silent aim",
	desc = "Routes hits through a separate raycast so your camera never moves",
})

silent:Toggle({
	title = "Enabled",
	value = false,
	callback = function(state)
		print("[Saint] Silent " .. tostring(state))
	end,
})

silent:Slider({
	title = "Prediction",
	min = 0,
	max = 1,
	decimals = 2,
	value = 0.35,
	callback = function(number)
		print("[Saint] Prediction " .. number)
	end,
})

silent:Keybind({
	title = "Trigger",
	key = Enum.KeyCode.Q,
	mode = "hold",
	callback = function(active)
		print("[Saint] Trigger " .. tostring(active))
	end,
})

settings:Group("Interface")

settings:TextBox({
	title = "Profile",
	placeholder = "profile name",
	text = "default",
	callback = function(text)
		print("[Saint] Profile " .. text)
	end,
})

settings:Toggle({
	title = "Animations",
	value = true,
	callback = function(state)
		print("[Saint] Animations " .. tostring(state))
	end,
})

settings:Toggle({
	title = "Watermark",
	desc = "Shows the fps counter in the corner",
	value = false,
	callback = function(state)
		print("[Saint] Watermark " .. tostring(state))
	end,
})

settings:Keybind({
	title = "NoClip",
	key = Enum.KeyCode.B,
	callback = function(active)
		print("[Saint] NoClip " .. tostring(active))
	end,
})

settings:Divider()

settings:Button({
	title = "Save profile",
	button = "Save",
	callback = function()
		print("[Saint] Profile saved")
	end,
})

settings:Button({
	title = "Reset everything",
	button = "Reset",
	callback = function()
		print("[Saint] Reset done")
	end,
})

settings:Button({
	title = "Unload",
	button = "Close",
	callback = function()
		window:Close()
	end,
})

window:Select("Home")

print("[Saint] loaded")
