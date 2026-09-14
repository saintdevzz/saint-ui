local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local function getParent()
	local ok, h = pcall(function() return gethui and gethui() end)
	if ok and typeof(h) == "Instance" then
		return h
	end
	local ok2, h2 = pcall(function() return get_hidden_gui and get_hidden_gui() end)
	if ok2 and typeof(h2) == "Instance" then
		return h2
	end
	if LocalPlayer then
		local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if pg then
			return pg
		end
		local ok3, pg2 = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 5) end)
		if ok3 and typeof(pg2) == "Instance" then
			return pg2
		end
	end
	return game:GetService("CoreGui")
end
local BG = Color3.fromRGB(15, 15, 15)
local BG_MISC = Color3.fromRGB(10, 10, 10)
local DIV = Color3.fromRGB(29, 29, 29)
local TEXT = Color3.fromRGB(232, 232, 232)
local TEXT_DIM = Color3.fromRGB(165, 165, 165)
local TEXT_FAINT = Color3.fromRGB(110, 110, 110)
local ICON_DIM = Color3.fromRGB(130, 130, 130)
local ICON_ON = Color3.fromRGB(235, 235, 235)
local PILL = Color3.fromRGB(36, 36, 36)
local HOVER = Color3.fromRGB(22, 22, 22)
local STROKE = Color3.fromRGB(38, 38, 38)
local OPT_BG = Color3.fromRGB(19, 19, 19)
local family = "rbxasset://fonts/families/GothamSSm.json"
local F_Med = Font.new(family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local F_Reg = Font.new(family, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local F_Bold = Font.new(family, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local NAV_W = 230
local CAT_W = 232
local SIDE_W = 210
local NAV_H = 44
local MOD_H = 48
local HEAD_H = 52
local CAT_HEAD_H = 46
local SIDE_HEAD_H = 40
local UILib = {}
local function create(class, props, parent)
	local i = Instance.new(class)
	for k, v in pairs(props or {}) do
		pcall(function() i[k] = v end)
	end
	if parent then
		i.Parent = parent
	end
	return i
end
local function corner(p, r)
	return create("UICorner", { CornerRadius = UDim.new(0, r or 6) }, p)
end
local function tween(i, props, t, style, dir)
	local tw = TweenService:Create(i, TweenInfo.new(t or 0.22, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end
local function pop(frame, s)
	local sc = frame:FindFirstChildOfClass("UIScale")
	if not sc then
		sc = create("UIScale", { Scale = 0.96 }, frame)
	end
	sc.Scale = s or 0.94
	tween(sc, { Scale = 1 }, 0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end
local function dragify(handle, frame)
	local dragging = false
	local sPos, sInput
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			sPos = frame.Position
			sInput = input.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - sInput
			frame.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
		end
	end)
end
local function assetId(value)
	if type(value) == "number" then
		return "rbxassetid://" .. tostring(math.floor(value))
	end
	if type(value) == "string" then
		local digits = value:match("^%s*(%d+)%s*$")
		if digits then
			return "rbxassetid://" .. digits
		end
		if value:match("^rbxassetid://") or value:match("^rbxasset://") or value:match("^https?://") then
			return value
		end
	end
	return nil
end
local function buildIcon(parent, value, size)
	local asset = assetId(value)
	if not asset then
		return nil
	end
	local s = size or 16
	local holder = create("Frame", {
		Name = "Icon",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(s, s)
	}, parent)
	create("ImageLabel", {
		Name = "Glyph",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = asset,
		ImageColor3 = ICON_DIM,
		ScaleType = Enum.ScaleType.Fit
	}, holder)
	return holder
end
local function tintIcon(holder, color, t)
	if not holder then return end
	for _, d in ipairs(holder:GetDescendants()) do
		if d:IsA("ImageLabel") then
			tween(d, { ImageColor3 = color }, t or 0.22)
		end
	end
end
local function bar(parent, size, pos, color)
	return create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = size,
		Position = pos,
		BackgroundColor3 = color,
		BorderSizePixel = 0
	}, parent)
end
local function diag(parent, cx, cy, len, thick, color, rot)
	return create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(len, thick),
		Position = UDim2.fromOffset(cx, cy),
		Rotation = rot,
		BackgroundColor3 = color,
		BorderSizePixel = 0
	}, parent)
end
local function drawChevron(parent, color)
	local h = create("Frame", {
		Name = "Chev",
		Size = UDim2.fromOffset(12, 12),
		BackgroundTransparency = 1
	}, parent)
	diag(h, 6, 4, 7, 1.6, color or Color3.fromRGB(95, 95, 95), -45)
	local b = diag(h, 6, 8, 7, 1.6, color or Color3.fromRGB(95, 95, 95), 45)
	b.Position = UDim2.fromOffset(6, 8)
	return h
end
local function drawCaret(parent, color)
	local h = create("Frame", {
		Name = "Caret",
		Size = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 1
	}, parent)
	diag(h, 5, 7, 7, 1.6, color or Color3.fromRGB(120, 120, 120), -45)
	diag(h, 9, 7, 7, 1.6, color or Color3.fromRGB(120, 120, 120), 45)
	return h
end
local function drawX(parent, color)
	local h = create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(12, 12)
	}, parent)
	diag(h, 6, 6, 10, 1.6, color or Color3.fromRGB(140, 140, 140), 45)
	diag(h, 6, 6, 10, 1.6, color or Color3.fromRGB(140, 140, 140), -45)
	return h
end
local function drawGear(parent, color)
	local c = color or Color3.fromRGB(140, 140, 140)
	local h = create("Frame", {
		Name = "Gear",
		Size = UDim2.fromOffset(20, 20),
		BackgroundTransparency = 1
	}, parent)
	bar(h, UDim2.fromOffset(14, 1.6), UDim2.fromOffset(10, 10), c)
	bar(h, UDim2.fromOffset(1.6, 14), UDim2.fromOffset(10, 10), c)
	diag(h, 10, 10, 13, 1.6, c, 45)
	diag(h, 10, 10, 13, 1.6, c, -45)
	local ring = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(9, 9),
		Position = UDim2.fromOffset(10, 10),
		BackgroundColor3 = Color3.fromRGB(15, 15, 15),
		BorderSizePixel = 0
	}, h)
	corner(ring, 9)
	create("UIStroke", { Color = c, Thickness = 1.6, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, ring)
	return h
end
local function drawPerson(parent, color)
	local c = color or Color3.fromRGB(150, 150, 150)
	local h = create("Frame", {
		Name = "User",
		Size = UDim2.fromOffset(18, 18),
		BackgroundTransparency = 1
	}, parent)
	local hd = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromOffset(7, 7),
		Position = UDim2.new(0.5, 0, 0, 1),
		BackgroundColor3 = c,
		BorderSizePixel = 0
	}, h)
	corner(hd, 7)
	local bd = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.fromOffset(14, 7),
		Position = UDim2.new(0.5, 0, 1, -1),
		BackgroundColor3 = c,
		BorderSizePixel = 0
	}, h)
	corner(bd, 4)
	return h
end
local function drawHamburger(parent, color)
	local c = color or Color3.fromRGB(150, 150, 150)
	local h = create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(14, 12)
	}, parent)
	bar(h, UDim2.fromOffset(12, 1.6), UDim2.fromOffset(7, 2), c)
	bar(h, UDim2.fromOffset(12, 1.6), UDim2.fromOffset(7, 6), c)
	bar(h, UDim2.fromOffset(12, 1.6), UDim2.fromOffset(7, 10), c)
	return h
end
local function drawSliders(parent, color)
	local c = color or Color3.fromRGB(150, 150, 150)
	local h = create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(14, 12)
	}, parent)
	bar(h, UDim2.fromOffset(12, 1.5), UDim2.fromOffset(7, 2), c)
	bar(h, UDim2.fromOffset(12, 1.5), UDim2.fromOffset(7, 10), c)
	local k1 = bar(h, UDim2.fromOffset(4, 4), UDim2.fromOffset(4, 2), c)
	corner(k1, 2)
	local k2 = bar(h, UDim2.fromOffset(4, 4), UDim2.fromOffset(10, 10), c)
	corner(k2, 2)
	return h
end
local function dotsIndicator(parent, color)
	local h = create("Frame", {
		Name = "Dots",
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1
	}, parent)
	for i = 0, 2 do
		local d = create("Frame", {
			Size = UDim2.fromOffset(3, 3),
			Position = UDim2.fromOffset(6, 1 + i * 5),
			BackgroundColor3 = color or Color3.fromRGB(120, 120, 120),
			BorderSizePixel = 0
		}, h)
		corner(d, 3)
	end
	return h
end
local function optLabel(parent, order, title, h)
	local f = create("Frame", {
		Size = UDim2.new(1, 0, 0, h or 34),
		BackgroundTransparency = 1,
		LayoutOrder = order
	}, parent)
	create("TextLabel", {
		Position = UDim2.fromOffset(2, 0),
		Size = UDim2.new(1, -70, 1, 0),
		BackgroundTransparency = 1,
		FontFace = F_Reg,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Color3.fromRGB(180, 180, 180),
		Text = title or ""
	}, f)
	return f
end
local function optToggle(parent, order, cfg)
	cfg = cfg or {}
	local f = optLabel(parent, order, cfg.title or "Toggle", 30)
	local val = cfg.value == true
	local tr = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(34, 18),
		BackgroundColor3 = val and TEXT or Color3.fromRGB(50, 50, 50),
		Text = "",
		AutoButtonColor = false
	}, f)
	corner(tr, 9)
	local knob = create("Frame", {
		Size = UDim2.fromOffset(12, 12),
		Position = val and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
		BackgroundColor3 = val and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	}, tr)
	corner(knob, 6)
	tr.MouseButton1Click:Connect(function()
		val = not val
		tween(tr, { BackgroundColor3 = val and TEXT or Color3.fromRGB(50, 50, 50) }, 0.22)
		tween(knob, { Position = val and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		tween(knob, { BackgroundColor3 = val and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(255, 255, 255) }, 0.22)
		if cfg.callback then
			cfg.callback(val)
		end
	end)
	return f
end
local function optSlider(parent, order, cfg)
	cfg = cfg or {}
	local min = cfg.min or 0
	local max = cfg.max or 100
	local decimals = cfg.decimals or 0
	local suffix = cfg.suffix or ""
	local val = cfg.value or min
	local title = cfg.title or "Slider"
	local range = max - min
	if range == 0 then range = 1 end
	local f = optLabel(parent, order, title, 40)
	local lbl = f:FindFirstChildOfClass("TextLabel")
	local track = create("Frame", {
		Size = UDim2.new(1, 0, 0, 4),
		Position = UDim2.new(0, 0, 1, -8),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderSizePixel = 0
	}, f)
	corner(track, 2)
	local fill = create("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = TEXT,
		BorderSizePixel = 0
	}, track)
	corner(fill, 2)
	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(12, 12),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = TEXT,
		BorderSizePixel = 0,
		ZIndex = 3
	}, track)
	corner(knob, 6)
	local hit = create("TextButton", {
		Size = UDim2.new(1, 12, 0, 22),
		Position = UDim2.new(0, -6, 0.5, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 4
	}, track)
	local function quantize(raw)
		if decimals > 0 then
			local scale = 10 ^ decimals
			return math.floor(raw * scale + 0.5) / scale
		end
		return math.floor(raw + 0.5)
	end
	local function render()
		local text
		if decimals > 0 then
			text = string.format("%." .. decimals .. "f", val)
		else
			text = tostring(math.floor(val + 0.5))
		end
		if lbl then
			lbl.Text = title .. "  " .. text .. suffix
		end
		local alpha = (val - min) / range
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
	end
	local dragging = false
	local function apply(inputX, fire)
		local ap = track.AbsolutePosition
		local size = track.AbsoluteSize
		if size.X <= 0 then return end
		local alpha = math.clamp((inputX - ap.X) / size.X, 0, 1)
		val = math.clamp(quantize(min + range * alpha), min, max)
		render()
		if fire and cfg.callback then
			cfg.callback(val)
		end
	end
	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			apply(input.Position.X, true)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			apply(input.Position.X, true)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				dragging = false
				if cfg.callback then
					cfg.callback(val)
				end
			end
		end
	end)
	render()
	return f
end
local function optDropdown(parent, order, cfg, closers)
	cfg = cfg or {}
	local options = cfg.options or {}
	local selected = cfg.default
	local f = optLabel(parent, order, cfg.title or "Dropdown", 34)
	local shell = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(80, 22),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		Text = "",
		AutoButtonColor = false
	}, f)
	corner(shell, 5)
	local label = create("TextLabel", {
		Position = UDim2.fromOffset(8, 0),
		Size = UDim2.new(1, -16, 1, 0),
		BackgroundTransparency = 1,
		FontFace = F_Reg,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = selected and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(140, 140, 140),
		Text = tostring(selected or cfg.placeholder or "Select")
	}, shell)
	local node = parent
	while node and not node:IsA("ScreenGui") do
		node = node.Parent
	end
	if not node then
		return f
	end
	local list = create("Frame", {
		Name = "DropdownList",
		Size = UDim2.fromOffset(112, 0),
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 60
	}, node)
	corner(list, 6)
	create("UIStroke", { Color = STROKE, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, list)
	create("UIScale", { Scale = 1 }, list)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 5),
		PaddingLeft = UDim.new(0, 5),
		PaddingRight = UDim.new(0, 5)
	}, list)
	create("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, list)
	local entries = {}
	local open = false
	local function listHeight()
		local visible = #options
		if visible == 0 then visible = 1 end
		return visible * 26 + math.max(visible - 1, 0) * 2 + 10
	end
	local function place()
		local ap = shell.AbsolutePosition
		local as = shell.AbsoluteSize
		local h = listHeight()
		local vp = Vector2.new(1920, 1080)
		pcall(function()
			if workspace.CurrentCamera then
				vp = workspace.CurrentCamera.ViewportSize
			end
		end)
		local x = ap.X
		local y = ap.Y + as.Y + 4
		if y + h > vp.Y - 8 then
			y = ap.Y - h - 4
		end
		if x + 112 > vp.X - 8 then
			x = vp.X - 120
		end
		if x < 8 then x = 8 end
		if y < 8 then y = 8 end
		list.Size = UDim2.fromOffset(112, h)
		list.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
	end
	local function close()
		if not open then return end
		open = false
		local sc = list:FindFirstChildOfClass("UIScale")
		if sc then
			tween(sc, { Scale = 0.96 }, 0.12)
		end
		task.delay(0.1, function()
			if not open then
				list.Visible = false
			end
		end)
	end
	local function paint()
		for i, entry in ipairs(entries) do
			if options[i] == selected then
				entry.TextColor3 = Color3.fromRGB(255, 255, 255)
				entry.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
			else
				entry.TextColor3 = Color3.fromRGB(180, 180, 180)
				entry.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
			end
		end
	end
	local function choose(option)
		selected = option
		label.Text = tostring(option)
		label.TextColor3 = Color3.fromRGB(200, 200, 200)
		paint()
		close()
		if cfg.callback then
			cfg.callback(option)
		end
	end
	for i, option in ipairs(options) do
		local entry = create("TextButton", {
			Size = UDim2.new(1, 0, 0, 26),
			BackgroundColor3 = Color3.fromRGB(26, 26, 26),
			Text = tostring(option),
			FontFace = F_Reg,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.fromRGB(180, 180, 180),
			AutoButtonColor = false,
			LayoutOrder = i,
			ZIndex = 61
		}, list)
		corner(entry, 4)
		create("UIPadding", { PaddingLeft = UDim.new(0, 8) }, entry)
		entry.MouseEnter:Connect(function()
			tween(entry, { BackgroundColor3 = Color3.fromRGB(40, 40, 40) }, 0.15)
		end)
		entry.MouseLeave:Connect(function()
			if options[i] ~= selected then
				tween(entry, { BackgroundColor3 = Color3.fromRGB(26, 26, 26) }, 0.15)
			end
		end)
		entry.MouseButton1Click:Connect(function()
			choose(option)
		end)
		entries[i] = entry
	end
	paint()
	shell.MouseEnter:Connect(function()
		tween(shell, { BackgroundColor3 = Color3.fromRGB(54, 54, 54) }, 0.2)
	end)
	shell.MouseLeave:Connect(function()
		tween(shell, { BackgroundColor3 = Color3.fromRGB(40, 40, 40) }, 0.2)
	end)
	shell.MouseButton1Click:Connect(function()
		if open then
			close()
			return
		end
		open = true
		place()
		list.Visible = true
		local sc = list:FindFirstChildOfClass("UIScale")
		if sc then
			sc.Scale = 0.94
			tween(sc, { Scale = 1 }, 0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		end
	end)
	if closers then
		table.insert(closers, close)
	end
	return f
end
local function optButton(parent, order, cfg)
	cfg = cfg or {}
	local f = optLabel(parent, order, cfg.title or "Button", 34)
	local b = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(70, 24),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		FontFace = F_Med,
		TextSize = 12,
		TextColor3 = TEXT,
		Text = tostring(cfg.button or "Run"),
		AutoButtonColor = false
	}, f)
	corner(b, 5)
	b.MouseEnter:Connect(function()
		tween(b, { BackgroundColor3 = Color3.fromRGB(60, 60, 60), Size = UDim2.fromOffset(74, 26) }, 0.2)
	end)
	b.MouseLeave:Connect(function()
		tween(b, { BackgroundColor3 = Color3.fromRGB(40, 40, 40), Size = UDim2.fromOffset(70, 24) }, 0.2)
	end)
	b.MouseButton1Click:Connect(function()
		if cfg.callback then
			cfg.callback()
		end
	end)
	return f
end
local function optKeybind(parent, order, cfg)
	cfg = cfg or {}
	local key = cfg.key
	local listening = false
	local f = optLabel(parent, order, cfg.title or "Keybind", 34)
	local shell = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(76, 22),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		FontFace = F_Reg,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		Text = key and key.Name or "None",
		AutoButtonColor = false
	}, f)
	corner(shell, 5)
	shell.MouseEnter:Connect(function()
		if not listening then
			tween(shell, { BackgroundColor3 = Color3.fromRGB(54, 54, 54) }, 0.2)
		end
	end)
	shell.MouseLeave:Connect(function()
		if not listening then
			tween(shell, { BackgroundColor3 = Color3.fromRGB(40, 40, 40) }, 0.2)
		end
	end)
	shell.MouseButton1Click:Connect(function()
		if listening then return end
		listening = true
		shell.Text = "Press a key..."
		shell.TextColor3 = Color3.fromRGB(140, 140, 140)
	end)
	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Unknown then return end
				key = input.KeyCode
			elseif input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.MouseButton2
				or input.UserInputType == Enum.UserInputType.MouseButton3 then
				key = input.UserInputType
			else
				return
			end
			listening = false
			shell.Text = key and (key.Name or tostring(key)) or "None"
			shell.TextColor3 = Color3.fromRGB(200, 200, 200)
			if cfg.callback then
				cfg.callback(key)
			end
			return
		end
		if not key then return end
		local matches
		if typeof(key) == "EnumUserInputType" then
			matches = input.UserInputType == key
		else
			matches = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key
		end
		if matches then
			if cfg.callback then
				cfg.callback(key)
			end
		end
	end)
	return f
end
function UILib:Window(config)
	config = config or {}
	local self = {}
	self.pages = {}
	self.order = {}
	self.current = nil
	self.open = true
	self.connections = {}
	local root = config.parent or getParent()
	local guiName = config.name or "MIGUEL"
	local function purge(list)
		for _, child in ipairs(list) do
			if child:IsA("ScreenGui") and (child.Name == guiName or child.Name == "VapeUI" or child.Name == "MIGUEL") then
				pcall(function()
					child:Destroy()
				end)
			end
		end
	end
	pcall(function()
		purge(root:GetChildren())
	end)
	pcall(function()
		local core = game:GetService("CoreGui")
		if core and core ~= root then
			purge(core:GetChildren())
		end
	end)
	local gui = create("ScreenGui", {
		Name = guiName,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 100
	}, root)
	local main = create("Frame", {
		Name = "Nav",
		Size = UDim2.fromOffset(NAV_W, 600),
		Position = UDim2.new(0.5, -NAV_W - 6, 0.5, -300),
		BackgroundColor3 = BG,
		BorderSizePixel = 0,
		Active = true
	}, gui)
	corner(main, 6)
	create("UIStroke", { Color = STROKE, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, main)
	create("UIScale", { Scale = 1 }, main)
	pop(main, 0.94)
	local head = create("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, HEAD_H),
		BackgroundTransparency = 1
	}, main)
	create("TextLabel", {
		Name = "Logo",
		Position = UDim2.fromOffset(16, 13),
		Size = UDim2.fromOffset(130, 26),
		BackgroundTransparency = 1,
		RichText = true,
		FontFace = F_Bold,
		TextSize = 20,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Text = 'MIGUEL'
	}, head)
	local gearBtn = create("TextButton", {
		Name = "Settings",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false
	}, head)
	local gearIcon = drawGear(gearBtn, Color3.fromRGB(140, 140, 140))
	gearIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	gearIcon.Position = UDim2.fromScale(0.5, 0.5)
	gearBtn.MouseEnter:Connect(function()
		tween(gearIcon, { Rotation = 50 }, 0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end)
	gearBtn.MouseLeave:Connect(function()
		tween(gearIcon, { Rotation = 0 }, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	end)
	create("Frame", {
		Name = "Div",
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.fromOffset(0, HEAD_H - 1),
		BackgroundColor3 = DIV,
		BorderSizePixel = 0
	}, main)
	local listHolder = create("Frame", {
		Name = "List",
		Position = UDim2.fromOffset(0, HEAD_H),
		Size = UDim2.new(1, 0, 1, -(HEAD_H + 48)),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}, main)
	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 0)
	}, listHolder)
	create("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -48),
		BackgroundColor3 = DIV,
		BorderSizePixel = 0
	}, main)
	local foot = create("Frame", {
		Size = UDim2.new(1, 0, 0, 47),
		Position = UDim2.new(0, 0, 1, -47),
		BackgroundTransparency = 1
	}, main)
	local userBtn = create("TextButton", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.fromOffset(34, 47),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false
	}, foot)
	local userIcon = drawPerson(userBtn, Color3.fromRGB(150, 150, 150))
	userIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	userIcon.Position = UDim2.fromScale(0.5, 0.5)
	local sBtn = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -40, 0.5, 0),
		Size = UDim2.fromOffset(24, 24),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false
	}, foot)
	local sIcon = drawSliders(sBtn, Color3.fromRGB(150, 150, 150))
	sIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	sIcon.Position = UDim2.fromScale(0.5, 0.5)
	local mBtn = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(24, 24),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false
	}, foot)
	local mIcon = drawHamburger(mBtn, Color3.fromRGB(150, 150, 150))
	mIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	mIcon.Position = UDim2.fromScale(0.5, 0.5)
	dragify(head, main)
	self.gui = gui
	self.main = main
	self.listHolder = listHolder
	self._navCount = 0
	self._miscBuilt = false
	self.toggleKey = config.toggleKey or Enum.KeyCode.RightShift
	local function fitMain(animate)
		local h = HEAD_H + 48
		for _, child in ipairs(listHolder:GetChildren()) do
			if child:IsA("GuiObject") then
				h = h + child.Size.Y.Offset
			end
		end
		local target = UDim2.fromOffset(NAV_W, h)
		if animate then
			tween(main, { Size = target }, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		else
			main.Size = target
		end
	end
	local function buildMiscLabel()
		if self._miscBuilt then return end
		self._miscBuilt = true
		local wrap = create("Frame", {
			Name = "MISC",
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = BG_MISC,
			BorderSizePixel = 0,
			LayoutOrder = 900
		}, listHolder)
		create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = DIV,
			BorderSizePixel = 0
		}, wrap)
		create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1),
			BackgroundColor3 = DIV,
			BorderSizePixel = 0
		}, wrap)
		create("TextLabel", {
			Position = UDim2.fromOffset(16, 0),
			Size = UDim2.new(1, -32, 1, 0),
			BackgroundTransparency = 1,
			FontFace = F_Bold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = TEXT_FAINT,
			Text = "MISC"
		}, wrap)
		fitMain(false)
	end
	local function closeAllSidePanels()
		for _, p in ipairs(self.order) do
			if p._floats then
				for _, cl in ipairs(p._floats) do
					cl()
				end
			end
			if p.modules then
				for _, m in ipairs(p.modules) do
					if m.sidePanels then
						for _, sp in ipairs(m.sidePanels) do
							if sp.frame then
								sp.frame.Visible = false
							end
						end
					end
					if m._sideOpen ~= nil then
						m._sideOpen = false
					end
				end
			end
		end
	end
	function self:Page(nameOrConfig, iconOverride)
		local cfg = {}
		if type(nameOrConfig) == "table" then
			cfg = nameOrConfig
		else
			cfg.title = nameOrConfig
			cfg.icon = iconOverride
		end
		local name = cfg.title or cfg.name or "Page"
		local isMisc = cfg.misc == true or cfg.section == "MISC" or name == "Friends" or name == "Profiles" or name == "Macros"
		if isMisc then
			buildMiscLabel()
		end
		self._navCount = self._navCount + 1
		local order = isMisc and (1000 + self._navCount) or self._navCount
		local entry = create("TextButton", {
			Name = name .. "Entry",
			Size = UDim2.new(1, 0, 0, NAV_H),
			BackgroundColor3 = HOVER,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = order
		}, listHolder)
		local iconAsset = assetId(cfg.icon)
		local hasIcon = iconAsset ~= nil
		local entryIcon
		if hasIcon then
			local entryIconHolder = create("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 17, 0.5, 0),
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1
			}, entry)
			entryIcon = buildIcon(entryIconHolder, iconAsset, 16)
		end
		local titleLbl = create("TextLabel", {
			Position = hasIcon and UDim2.fromOffset(42, 0) or UDim2.fromOffset(16, 0),
			Size = UDim2.new(1, hasIcon and -80 or -70, 1, 0),
			BackgroundTransparency = 1,
			FontFace = F_Med,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.fromRGB(205, 205, 205),
			Text = name
		}, entry)
		local chevHolder = create("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -14, 0.5, 0),
			Size = UDim2.fromOffset(16, 16),
			BackgroundTransparency = 1
		}, entry)
		local navDots = dotsIndicator(chevHolder, Color3.fromRGB(95, 95, 95))
		navDots.AnchorPoint = Vector2.new(0.5, 0.5)
		navDots.Position = UDim2.fromScale(0.5, 0.5)
		create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1),
			BackgroundColor3 = DIV,
			BorderSizePixel = 0
		}, entry)
		local pill
		local pillLbl
		if cfg.tag then
			pill = create("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -34, 0.5, 0),
				Size = UDim2.fromOffset(58, 22),
				BackgroundColor3 = PILL,
				BorderSizePixel = 0
			}, entry)
			corner(pill, 4)
			pillLbl = create("TextLabel", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				FontFace = F_Reg,
				TextSize = 12,
				TextColor3 = Color3.fromRGB(160, 160, 160),
				Text = tostring(cfg.tag)
			}, pill)
		end
		local cat = create("Frame", {
			Name = name .. "Panel",
			Size = UDim2.fromOffset(CAT_W, CAT_HEAD_H + 40),
			Position = UDim2.new(0.5, 6, 0.5, -300),
			BackgroundColor3 = BG,
			BorderSizePixel = 0,
			Visible = false
		}, gui)
		corner(cat, 6)
		create("UIStroke", { Color = STROKE, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, cat)
		create("UIScale", { Scale = 1 }, cat)
		local catHead = create("TextButton", {
			Name = "Head",
			Size = UDim2.new(1, 0, 0, CAT_HEAD_H),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false
		}, cat)
		if hasIcon then
			local ch = create("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1
			}, catHead)
			buildIcon(ch, iconAsset, 16)
		end
		create("TextLabel", {
			Position = UDim2.fromOffset(hasIcon and 42 or 16, 0),
			Size = UDim2.new(1, -70, 1, 0),
			BackgroundTransparency = 1,
			FontFace = F_Med,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = TEXT,
			Text = name
		}, catHead)
		local caretHolder = create("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -14, 0.5, 0),
			Size = UDim2.fromOffset(14, 14),
			BackgroundTransparency = 1
		}, catHead)
		local caret = drawCaret(caretHolder, Color3.fromRGB(120, 120, 120))
		create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.fromOffset(0, CAT_HEAD_H - 1),
			BackgroundColor3 = DIV,
			BorderSizePixel = 0
		}, cat)
		dragify(catHead, cat)
		local collapsed = false
		local catList = create("Frame", {
			Name = "Mods",
			Position = UDim2.fromOffset(0, CAT_HEAD_H),
			Size = UDim2.new(1, 0, 1, -CAT_HEAD_H),
			BackgroundTransparency = 1
		}, cat)
		create("UIPadding", {
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}, catList)
		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2)
		}, catList)
		local function fitCat(animate)
			if collapsed then return end
			local h = CAT_HEAD_H + 12
			for _, c in ipairs(catList:GetChildren()) do
				if c:IsA("GuiObject") then
					h = h + c.Size.Y.Offset + 2
				end
			end
			local target = UDim2.fromOffset(CAT_W, h)
			if animate then
				tween(cat, { Size = target }, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			else
				cat.Size = target
			end
		end
		catHead.MouseButton1Click:Connect(function()
			collapsed = not collapsed
			catList.Visible = not collapsed
			tween(caret, { Rotation = collapsed and 180 or 0 }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			if collapsed then
				tween(cat, { Size = UDim2.fromOffset(CAT_W, CAT_HEAD_H) }, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			else
				fitCat(true)
				pop(cat, 0.97)
			end
		end)
		local page = {}
		page.name = name
		page.entry = entry
		page.titleLbl = titleLbl
		page.entryIcon = entryIcon
		page.panel = cat
		page.list = catList
		page._count = 0
		page.modules = {}
		page._floats = {}
		page.open = false
		page.window = self
		function page:SetTag(t)
			if pillLbl then
				pillLbl.Text = tostring(t)
			elseif t then
				pill = create("Frame", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -34, 0.5, 0),
					Size = UDim2.fromOffset(58, 22),
					BackgroundColor3 = PILL,
					BorderSizePixel = 0
				}, entry)
				corner(pill, 4)
				pillLbl = create("TextLabel", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					FontFace = F_Reg,
					TextSize = 12,
					TextColor3 = Color3.fromRGB(160, 160, 160),
					Text = tostring(t)
				}, pill)
			end
		end
		function page:Module(nameOrCfg)
			local mc = {}
			if type(nameOrCfg) == "table" then
				mc = nameOrCfg
			else
				mc.title = nameOrCfg
			end
			local mname = mc.title or mc.name or "Module"
			page._count = page._count + 1
			local wrap = create("Frame", {
				Name = mname,
				Size = UDim2.new(1, 0, 0, MOD_H),
				BackgroundTransparency = 1,
				LayoutOrder = page._count * 10
			}, catList)
			local row = create("TextButton", {
				Name = "Row",
				Size = UDim2.new(1, 0, 0, MOD_H - 6),
				Position = UDim2.fromOffset(0, 0),
				BackgroundColor3 = HOVER,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false
			}, wrap)
			corner(row, 5)
			local t = create("TextLabel", {
				Position = UDim2.fromOffset(16, 0),
				Size = UDim2.new(1, -72, 1, 0),
				BackgroundTransparency = 1,
				FontFace = F_Reg,
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				Text = mname
			}, row)
			local chevBtn = create("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.fromOffset(20, 24),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				Visible = false
			}, row)
			local chevIcon = drawChevron(chevBtn, Color3.fromRGB(125, 125, 125))
			chevIcon.AnchorPoint = Vector2.new(0.5, 0.5)
			chevIcon.Position = UDim2.fromScale(0.5, 0.5)
			local dotsBtn = create("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.fromOffset(22, 24),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				Visible = false
			}, row)
			local dh = dotsIndicator(dotsBtn, Color3.fromRGB(125, 125, 125))
			dh.Position = UDim2.fromScale(0.5, 0.5)
			dh.AnchorPoint = Vector2.new(0.5, 0.5)
			row.MouseEnter:Connect(function()
				tween(row, { BackgroundTransparency = 0 }, 0.22)
				tween(t, { TextColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.fromOffset(18, 0) }, 0.25)
				tween(dh, { Rotation = 90 }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			end)
			row.MouseLeave:Connect(function()
				tween(row, { BackgroundTransparency = 1 }, 0.25)
				tween(t, { Position = UDim2.fromOffset(16, 0) }, 0.25)
				tween(dh, { Rotation = 0 }, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			end)
			local opts = create("Frame", {
				Name = "Options",
				Size = UDim2.new(1, -24, 0, 0),
				Position = UDim2.new(0, 12, 0, MOD_H - 4),
				BackgroundColor3 = OPT_BG,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Visible = false,
				AutomaticSize = Enum.AutomaticSize.Y
			}, wrap)
			corner(opts, 5)
			create("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, opts)
			create("UIPadding", {
				PaddingTop = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6),
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8)
			}, opts)
			local inlineOpen = false
			local function refreshWrap(animate)
				local target
				if inlineOpen then
					target = UDim2.new(1, 0, 0, (MOD_H - 4) + opts.AbsoluteSize.Y + 8)
				else
					target = UDim2.new(1, 0, 0, MOD_H)
				end
				if animate then
					tween(wrap, { Size = target }, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				else
					wrap.Size = target
				end
				task.defer(function() fitCat(true) end)
			end
			opts:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() refreshWrap(false) end)
			local function setInline(v)
				inlineOpen = v
				if v then
					opts.Visible = true
					opts.BackgroundTransparency = 1
					tween(opts, { BackgroundTransparency = 0 }, 0.28)
					tween(chevIcon, { Rotation = 90 }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				else
					tween(opts, { BackgroundTransparency = 1 }, 0.2)
					tween(chevIcon, { Rotation = 0 }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
					task.delay(0.2, function()
						if not inlineOpen then
							opts.Visible = false
						end
					end)
				end
				refreshWrap(true)
			end
			chevBtn.MouseButton1Click:Connect(function() setInline(not inlineOpen) end)
			local mod = {}
			mod.row = row
			mod.title = t
			mod._box = opts
			mod._n = 0
			mod.sidePanels = {}
			mod._sideOpen = false
			local function layoutRowBtns(animate)
				local target = (#mod.sidePanels > 0) and UDim2.new(1, -36, 0.5, 0) or UDim2.new(1, -10, 0.5, 0)
				if animate then
					tween(chevBtn, { Position = target }, 0.25)
				else
					chevBtn.Position = target
				end
			end
			local function revealChev()
				mod._hasOptions = true
				if not chevBtn.Visible then
					chevBtn.Visible = true
					chevIcon.Rotation = 0
					tween(chevBtn, { BackgroundTransparency = 0 }, 0.2)
				end
				layoutRowBtns(true)
			end
			function mod:_optRow(title, h)
				mod._n = mod._n + 1
				revealChev()
				local f = optLabel(opts, mod._n, title, h)
				task.defer(function() refreshWrap(false) end)
				return f
			end
			function mod:Toggle(cfg)
				cfg = cfg or {}
				optToggle(opts, mod._n + 1, cfg)
				mod._n = mod._n + 1
				revealChev()
				return mod
			end
			function mod:Slider(cfg)
				cfg = cfg or {}
				optSlider(opts, mod._n + 1, cfg)
				mod._n = mod._n + 1
				revealChev()
				return mod
			end
			function mod:Dropdown(cfg)
				cfg = cfg or {}
				optDropdown(opts, mod._n + 1, cfg, page._floats)
				mod._n = mod._n + 1
				revealChev()
				return mod
			end
			function mod:Button(cfg)
				cfg = cfg or {}
				optButton(opts, mod._n + 1, cfg)
				mod._n = mod._n + 1
				revealChev()
				return mod
			end
			function mod:Keybind(cfg)
				cfg = cfg or {}
				optKeybind(opts, mod._n + 1, cfg)
				mod._n = mod._n + 1
				revealChev()
				return mod
			end
			function mod:Expand()
				if mod._hasOptions then
					setInline(true)
				end
				return mod
			end
			function mod:Collapse()
				setInline(false)
				return mod
			end
			function mod:IsExpanded()
				return inlineOpen
			end
			function mod:Panel(subTitle)
				local st = subTitle or (mname .. " Settings")
				local frame = create("Frame", {
					Name = st,
					Size = UDim2.fromOffset(SIDE_W, SIDE_HEAD_H + 16),
					BackgroundColor3 = BG,
					BorderSizePixel = 0,
					Visible = false
				}, gui)
				corner(frame, 6)
				create("UIStroke", { Color = STROKE, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, frame)
				create("UIScale", { Scale = 1 }, frame)
				local shead = create("TextButton", {
					Size = UDim2.new(1, 0, 0, SIDE_HEAD_H),
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false
				}, frame)
				create("TextLabel", {
					Position = UDim2.fromOffset(14, 0),
					Size = UDim2.new(1, -44, 1, 0),
					BackgroundTransparency = 1,
					FontFace = F_Med,
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = TEXT,
					Text = st
				}, shead)
				local xBtn = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -10, 0.5, 0),
					Size = UDim2.fromOffset(20, 20),
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false
				}, shead)
				local xIcon = drawX(xBtn, Color3.fromRGB(130, 130, 130))
				xIcon.AnchorPoint = Vector2.new(0.5, 0.5)
				xIcon.Position = UDim2.fromScale(0.5, 0.5)
				create("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.fromOffset(0, SIDE_HEAD_H - 1),
					BackgroundColor3 = DIV,
					BorderSizePixel = 0
				}, frame)
				dragify(shead, frame)
				local list = create("Frame", {
					Position = UDim2.fromOffset(0, SIDE_HEAD_H),
					Size = UDim2.new(1, 0, 1, -SIDE_HEAD_H),
					BackgroundTransparency = 1
				}, frame)
				create("UIPadding", {
					PaddingTop = UDim.new(0, 6),
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8)
				}, list)
				create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 2)
				}, list)
				local sp = {}
				sp.frame = frame
				sp.list = list
				sp._n = 0
				sp.title = st
				local function fitSide(animate)
					local h = SIDE_HEAD_H + 14
					for _, c in ipairs(list:GetChildren()) do
						if c:IsA("GuiObject") then
							h = h + c.Size.Y.Offset + 2
						end
					end
					local target = UDim2.fromOffset(SIDE_W, h)
					if animate then
						tween(frame, { Size = target }, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
					else
						frame.Size = target
					end
				end
				list:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() end)
				function sp:Toggle(cfg)
					sp._n = sp._n + 1
					optToggle(list, sp._n, cfg)
					task.defer(function() fitSide(false) end)
					return sp
				end
				function sp:Slider(cfg)
					sp._n = sp._n + 1
					optSlider(list, sp._n, cfg)
					task.defer(function() fitSide(false) end)
					return sp
				end
				function sp:Dropdown(cfg)
					sp._n = sp._n + 1
					optDropdown(list, sp._n, cfg)
					task.defer(function() fitSide(false) end)
					return sp
				end
				function sp:Button(cfg)
					sp._n = sp._n + 1
					optButton(list, sp._n, cfg)
					task.defer(function() fitSide(false) end)
					return sp
				end
				function sp:Keybind(cfg)
					sp._n = sp._n + 1
					optKeybind(list, sp._n, cfg)
					task.defer(function() fitSide(false) end)
					return sp
				end
				function sp:Show()
					local vp = Vector2.new(1920, 1080)
					pcall(function()
						if workspace.CurrentCamera then
							vp = workspace.CurrentCamera.ViewportSize
						end
					end)
				local ax = dotsBtn.AbsolutePosition.X + dotsBtn.AbsoluteSize.X + 8
				local ay = dotsBtn.AbsolutePosition.Y - 10
				local w = SIDE_W
				local h = frame.Size.Y.Offset
				if h < 60 then h = 120 end
				if ax + w > vp.X - 8 then
					ax = dotsBtn.AbsolutePosition.X - w - 8
				end
					if ay + h > vp.Y - 8 then
						ay = vp.Y - h - 8
					end
					if ay < 8 then ay = 8 end
					if ax < 8 then ax = 8 end
					frame.Position = UDim2.fromOffset(math.floor(ax), math.floor(ay))
					frame.Visible = true
					fitSide(false)
					pop(frame, 0.92)
				end
				function sp:Hide()
					tween(frame, { BackgroundTransparency = 0.4 }, 0.15)
					task.delay(0.12, function()
						frame.Visible = false
						frame.BackgroundTransparency = 0
					end)
				end
				xBtn.MouseButton1Click:Connect(function()
					mod._sideOpen = false
					sp:Hide()
				end)
				table.insert(mod.sidePanels, sp)
				if not dotsBtn.Visible then
					dotsBtn.Visible = true
				end
				layoutRowBtns(true)
				fitSide(false)
				return sp
			end
			local function toggleSide()
				if #mod.sidePanels == 0 then return end
				mod._sideOpen = not mod._sideOpen
				if mod._sideOpen then
					for _, sp in ipairs(mod.sidePanels) do
						sp:Show()
					end
					tween(dh, { Rotation = 90 }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				else
					for _, sp in ipairs(mod.sidePanels) do
						sp:Hide()
					end
					tween(dh, { Rotation = 0 }, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				end
			end
			dotsBtn.MouseButton1Click:Connect(toggleSide)
			local enabled = false
			row.MouseButton1Click:Connect(function()
				if mod._hasOptions then
					setInline(not inlineOpen)
					return
				end
				enabled = not enabled
				if enabled then
					tween(t, { TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.2)
				else
					tween(t, { TextColor3 = Color3.fromRGB(205, 205, 205) }, 0.2)
				end
				if mc.callback then
					mc.callback(enabled)
				end
			end)
			fitCat(false)
			table.insert(page.modules, mod)
			return mod
		end
		local function setPageOpen(p, v, entrance)
			p.open = v ~= false
			if p.open then
				for _, other in ipairs(self.order) do
					if other ~= p and other.open then
						other.open = false
						other.panel.Visible = false
						tween(other.titleLbl, { TextColor3 = Color3.fromRGB(205, 205, 205) }, 0.22)
						tween(other.entry, { BackgroundTransparency = 1 }, 0.22)
						tintIcon(other.entryIcon, ICON_DIM, 0.22)
						for _, cl in ipairs(other._floats) do
							cl()
						end
						for _, m in ipairs(other.modules) do
							m._sideOpen = false
							for _, sp in ipairs(m.sidePanels) do
								if sp.frame then
									sp.frame.Visible = false
								end
							end
						end
					end
				end
				p.panel.Visible = true
				fitCat(false)
				pop(p.panel, 0.96)
				tween(p.titleLbl, { TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.22)
				tween(p.entry, { BackgroundTransparency = 0 }, 0.22)
				tintIcon(p.entryIcon, ICON_ON, 0.22)
				if entrance then
					local idx = 0
					for _, w in ipairs(p.list:GetChildren()) do
						if w:IsA("Frame") then
							idx = idx + 1
							local r = w:FindFirstChild("Row")
							if r then
								local lbl
								for _, d in ipairs(r:GetChildren()) do
									if d:IsA("TextLabel") then
										lbl = d
										break
									end
								end
								if lbl then
									lbl.Position = UDim2.fromOffset(26, 0)
									local dly = idx * 0.035
									task.delay(dly, function()
										if lbl and lbl.Parent then
											tween(lbl, { Position = UDim2.fromOffset(16, 0) }, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
										end
									end)
								end
							end
						end
					end
				end
			else
				p.panel.Visible = false
				tween(p.titleLbl, { TextColor3 = Color3.fromRGB(205, 205, 205) }, 0.22)
				tween(p.entry, { BackgroundTransparency = 1 }, 0.22)
				tintIcon(p.entryIcon, ICON_DIM, 0.22)
				for _, cl in ipairs(p._floats) do
					cl()
				end
				for _, m in ipairs(p.modules) do
					m._sideOpen = false
					for _, sp in ipairs(m.sidePanels) do
						if sp.frame then
							sp.frame.Visible = false
						end
					end
				end
			end
		end
		page._setOpen = setPageOpen
		entry.MouseEnter:Connect(function()
			if not page.open then
				tween(entry, { BackgroundTransparency = 0 }, 0.22)
				tween(titleLbl, { TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.22)
				tween(chevHolder, { Position = UDim2.new(1, -12, 0.5, 0) }, 0.25)
			end
		end)
		entry.MouseLeave:Connect(function()
			if not page.open then
				tween(entry, { BackgroundTransparency = 1 }, 0.25)
				tween(titleLbl, { TextColor3 = Color3.fromRGB(205, 205, 205) }, 0.25)
				tween(chevHolder, { Position = UDim2.new(1, -14, 0.5, 0) }, 0.25)
			end
		end)
		entry.MouseButton1Click:Connect(function()
			self.current = page
			setPageOpen(page, not page.open, true)
		end)
		self.pages[name] = page
		table.insert(self.order, page)
		fitMain(true)
		if not self.current then
			self:Select(name)
		end
		return page
	end
	function self:Select(name)
		local target = self.pages[name]
		if not target then return false end
		self.current = target
		target._setOpen(true, true)
		return true
	end
	function self:SetOpen(v)
		self.open = v ~= false
		if not self.open then
			closeAllSidePanels()
		end
		local sc = self.main:FindFirstChildOfClass("UIScale")
		if self.open then
			gui.Enabled = true
			if sc then
				sc.Scale = 0.93
				tween(sc, { Scale = 1 }, 0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			end
		else
			if sc then
				tween(sc, { Scale = 0.95 }, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
			end
			task.delay(0.16, function()
				if not self.open then
					gui.Enabled = false
				end
			end)
		end
		return self.open
	end
	function self:Toggle()
		return self:SetOpen(not self.open)
	end
	function self:SetToggleKey(key)
		self.toggleKey = key
		return self
	end
	function self:Destroy()
		for _, c in ipairs(self.connections) do
			pcall(function() c:Disconnect() end)
		end
		self.connections = {}
		pcall(function() gui:Destroy() end)
		self.pages = {}
		self.order = {}
		self.current = nil
	end
	table.insert(self.connections, UserInputService.InputBegan:Connect(function(input, gpe)
		if input.KeyCode == self.toggleKey then
			self:SetOpen(not self.open)
			return
		end
		if gpe then return end
	end))
	return self
end
return UILib
