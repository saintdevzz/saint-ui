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
local ACCENT = Color3.fromRGB(61, 232, 127)
local PILL = Color3.fromRGB(36, 36, 36)
local HOVER = Color3.fromRGB(22, 22, 22)
local STROKE = Color3.fromRGB(38, 38, 38)
local family = "rbxasset://fonts/families/GothamSSm.json"
local F_Med = Font.new(family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local F_Reg = Font.new(family, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local F_Bold = Font.new(family, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local NAV_W = 230
local CAT_W = 232
local NAV_H = 44
local MOD_H = 48
local HEAD_H = 52
local CAT_HEAD_H = 46
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
local function tween(i, props, t)
	local tw = TweenService:Create(i, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
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
local ICONS = {
	Combat = "☄",
	Render = "◉",
	Utility = "✕",
	World = "⊕",
	Inventory = "▤",
	Minigames = "♞",
	Other = "⧉",
	Friends = "",
	Profiles = "",
	Macros = ""
}
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
function UILib:Window(config)
	config = config or {}
	local self = {}
	self.pages = {}
	self.order = {}
	self.current = nil
	self.open = true
	self.connections = {}
	local root = config.parent or getParent()
	local gui = create("ScreenGui", {
		Name = config.name or "VapeUI",
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
		Text = 'VAPE<font color="rgb(61,232,127)"> V4</font>'
	}, head)
	local gear = create("TextButton", {
		Name = "Settings",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		FontFace = F_Reg,
		TextSize = 18,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		Text = "⚙",
		AutoButtonColor = false
	}, head)
	gear.MouseEnter:Connect(function() gear.TextColor3 = TEXT end)
	gear.MouseLeave:Connect(function() gear.TextColor3 = Color3.fromRGB(140, 140, 140) end)
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
	create("TextButton", {
		Position = UDim2.fromOffset(16, 0),
		Size = UDim2.fromOffset(30, 47),
		BackgroundTransparency = 1,
		Text = "●",
		FontFace = F_Reg,
		TextSize = 16,
		TextColor3 = Color3.fromRGB(150, 150, 150),
		AutoButtonColor = false
	}, foot)
	create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -40, 0.5, 0),
		Size = UDim2.fromOffset(24, 24),
		BackgroundTransparency = 1,
		Text = "✦",
		TextSize = 14,
		FontFace = F_Reg,
		TextColor3 = Color3.fromRGB(150, 150, 150),
		AutoButtonColor = false
	}, foot)
	create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(24, 24),
		BackgroundTransparency = 1,
		Text = "☰",
		TextSize = 14,
		FontFace = F_Reg,
		TextColor3 = Color3.fromRGB(150, 150, 150),
		AutoButtonColor = false
	}, foot)
	dragify(head, main)
	self.gui = gui
	self.main = main
	self.listHolder = listHolder
	self._navCount = 0
	self._miscBuilt = false
	self.toggleKey = config.toggleKey or Enum.KeyCode.RightShift
	local function fitMain()
		local h = HEAD_H + 48
		for _, child in ipairs(listHolder:GetChildren()) do
			if child:IsA("GuiObject") then
				h = h + child.Size.Y.Offset
			end
		end
		main.Size = UDim2.fromOffset(NAV_W, h)
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
			TextColor3 = Color3.fromRGB(110, 110, 110),
			Text = "MISC"
		}, wrap)
		fitMain()
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
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = order
		}, listHolder)
		local hasIcon = not isMisc
		local iconChar = cfg.icon or ICONS[name] or ""
		if type(iconChar) == "number" then
			iconChar = ""
		end
		local iconLbl
		if hasIcon then
			iconLbl = create("TextLabel", {
				Position = UDim2.fromOffset(17, 0),
				Size = UDim2.fromOffset(18, NAV_H),
				BackgroundTransparency = 1,
				FontFace = F_Bold,
				TextSize = 15,
				TextColor3 = Color3.fromRGB(170, 170, 170),
				Text = tostring(iconChar)
			}, entry)
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
		create("TextLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -16, 0.5, 0),
			Size = UDim2.fromOffset(12, NAV_H),
			BackgroundTransparency = 1,
			FontFace = F_Reg,
			TextSize = 16,
			TextColor3 = Color3.fromRGB(95, 95, 95),
			Text = "›"
		}, entry)
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
		local catHead = create("TextButton", {
			Name = "Head",
			Size = UDim2.new(1, 0, 0, CAT_HEAD_H),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false
		}, cat)
		if hasIcon then
			create("TextLabel", {
				Position = UDim2.fromOffset(16, 0),
				Size = UDim2.fromOffset(18, CAT_HEAD_H),
				BackgroundTransparency = 1,
				FontFace = F_Bold,
				TextSize = 15,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Text = tostring(iconChar)
			}, catHead)
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
		local caretLbl = create("TextLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -16, 0.5, 0),
			Size = UDim2.fromOffset(16, CAT_HEAD_H),
			BackgroundTransparency = 1,
			FontFace = F_Reg,
			TextSize = 15,
			TextColor3 = Color3.fromRGB(120, 120, 120),
			Text = "︿"
		}, catHead)
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
		local function fitCat()
			if collapsed then return end
			local h = CAT_HEAD_H + 12
			for _, c in ipairs(catList:GetChildren()) do
				if c:IsA("GuiObject") then
					h = h + c.Size.Y.Offset + 2
				end
			end
			cat.Size = UDim2.fromOffset(CAT_W, h)
			local mp = main.Position
			cat.Position = UDim2.new(0.5, 6, mp.Y.Scale, mp.Y.Offset)
		end
		catHead.MouseButton1Click:Connect(function()
			collapsed = not collapsed
			catList.Visible = not collapsed
			caretLbl.Text = collapsed and "﹀" or "︿"
			if collapsed then
				cat.Size = UDim2.fromOffset(CAT_W, CAT_HEAD_H)
			else
				fitCat()
			end
		end)
		local page = {}
		page.name = name
		page.entry = entry
		page.titleLbl = titleLbl
		page.iconLbl = iconLbl
		page.panel = cat
		page.list = catList
		page._count = 0
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
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false
			}, wrap)
			local t = create("TextLabel", {
				Position = UDim2.fromOffset(16, 0),
				Size = UDim2.new(1, -50, 1, 0),
				BackgroundTransparency = 1,
				FontFace = F_Reg,
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				Text = mname
			}, row)
			local dotsBtn = create("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.fromOffset(22, 24),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false
			}, row)
			local dh = dotsIndicator(dotsBtn, Color3.fromRGB(125, 125, 125))
			dh.Position = UDim2.fromScale(0.5, 0.5)
			dh.AnchorPoint = Vector2.new(0.5, 0.5)
			row.MouseEnter:Connect(function()
				tween(row, { BackgroundColor3 = HOVER, BackgroundTransparency = 0 }, 0.12)
				if row.BackgroundTransparency ~= 0 then
					row.BackgroundTransparency = 0
				end
			end)
			row.MouseLeave:Connect(function()
				tween(row, { BackgroundTransparency = 1 }, 0.12)
			end)
			local opts = create("Frame", {
				Name = "Options",
				Size = UDim2.new(1, -24, 0, 0),
				Position = UDim2.new(0, 12, 0, MOD_H - 4),
				BackgroundColor3 = Color3.fromRGB(19, 19, 19),
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
			local expanded = false
			local function refreshWrap()
				if expanded then
					wrap.Size = UDim2.new(1, 0, 0, (MOD_H - 4) + opts.AbsoluteSize.Y + 8)
				else
					wrap.Size = UDim2.new(1, 0, 0, MOD_H)
				end
				task.defer(fitCat)
			end
			opts:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshWrap)
			local function setExpanded(v)
				expanded = v
				opts.Visible = v
				refreshWrap()
			end
			dotsBtn.MouseButton1Click:Connect(function() setExpanded(not expanded) end)
			local enabled = false
			row.MouseButton1Click:Connect(function()
				enabled = not enabled
				if enabled then
					t.TextColor3 = Color3.fromRGB(255, 255, 255)
				else
					t.TextColor3 = Color3.fromRGB(205, 205, 205)
				end
				if mc.callback then
					mc.callback(enabled)
				end
			end)
			fitCat()
			local mod = {}
			mod.row = row
			mod.title = t
			mod._box = opts
			mod._n = 0
			function mod:_optRow(title, h)
				mod._n = mod._n + 1
				local f = create("Frame", {
					Size = UDim2.new(1, 0, 0, h or 34),
					BackgroundTransparency = 1,
					LayoutOrder = mod._n
				}, opts)
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
				task.defer(refreshWrap)
				return f
			end
			function mod:Toggle(cfg)
				cfg = cfg or {}
				local f = self:_optRow(cfg.title or "Toggle", 30)
				local val = cfg.value == true
				local tr = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(34, 18),
					BackgroundColor3 = val and ACCENT or Color3.fromRGB(50, 50, 50),
					Text = "",
					AutoButtonColor = false
				}, f)
				corner(tr, 9)
				local knob = create("Frame", {
					Size = UDim2.fromOffset(12, 12),
					Position = val and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0
				}, tr)
				corner(knob, 6)
				tr.MouseButton1Click:Connect(function()
					val = not val
					tr.BackgroundColor3 = val and ACCENT or Color3.fromRGB(50, 50, 50)
					knob.Position = val and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
					if cfg.callback then
						cfg.callback(val)
					end
				end)
				setExpanded(true)
				return mod
			end
			function mod:Slider(cfg)
				cfg = cfg or {}
				local min = cfg.min or 0
				local max = cfg.max or 100
				local val = cfg.value or min
				local f = self:_optRow((cfg.title or "Slider") .. "  " .. tostring(val), 40)
				local bar = create("Frame", {
					Size = UDim2.new(1, 0, 0, 4),
					Position = UDim2.new(0, 0, 1, -8),
					BackgroundColor3 = Color3.fromRGB(50, 50, 50),
					BorderSizePixel = 0
				}, f)
				corner(bar, 2)
				local fill = create("Frame", {
					Size = UDim2.new((val - min) / math.max(max - min, 1), 0, 1, 0),
					BackgroundColor3 = ACCENT,
					BorderSizePixel = 0
				}, bar)
				corner(fill, 2)
				setExpanded(true)
				return mod
			end
			function mod:Dropdown(cfg)
				cfg = cfg or {}
				local f = self:_optRow(cfg.title or "Dropdown", 34)
				create("TextLabel", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(80, 22),
					BackgroundColor3 = Color3.fromRGB(40, 40, 40),
					FontFace = F_Reg,
					TextSize = 12,
					TextColor3 = Color3.fromRGB(200, 200, 200),
					Text = tostring(cfg.default or cfg.placeholder or "Select")
				}, f)
				setExpanded(true)
				return mod
			end
			function mod:Button(cfg)
				cfg = cfg or {}
				local f = self:_optRow(cfg.title or "Button", 34)
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
				b.MouseButton1Click:Connect(function()
					if cfg.callback then
						cfg.callback()
					end
				end)
				setExpanded(true)
				return mod
			end
			function mod:Keybind(cfg)
				cfg = cfg or {}
				local f = self:_optRow(cfg.title or "Keybind", 34)
				create("TextLabel", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(60, 22),
					BackgroundColor3 = Color3.fromRGB(40, 40, 40),
					FontFace = F_Reg,
					TextSize = 12,
					TextColor3 = Color3.fromRGB(200, 200, 200),
					Text = cfg.key and cfg.key.Name or "None"
				}, f)
				setExpanded(true)
				return mod
			end
			return mod
		end
		entry.MouseEnter:Connect(function()
			if self.current ~= page then
				entry.BackgroundColor3 = HOVER
				entry.BackgroundTransparency = 0
			end
		end)
		entry.MouseLeave:Connect(function()
			if self.current ~= page then
				entry.BackgroundTransparency = 1
			end
		end)
		entry.MouseButton1Click:Connect(function() self:Select(name) end)
		self.pages[name] = page
		table.insert(self.order, page)
		fitMain()
		for _, p in ipairs(self.order) do
			if p.panel then
				p.panel.Position = UDim2.new(0.5, 6, main.Position.Y.Scale, main.Position.Y.Offset)
			end
		end
		if not self.current then
			self:Select(name)
		end
		return page
	end
	function self:Select(name)
		local target = self.pages[name]
		if not target then return false end
		self.current = target
		for _, p in ipairs(self.order) do
			local active = p == target
			p.panel.Visible = active
			if active then
				p.titleLbl.TextColor3 = ACCENT
				if p.iconLbl then
					p.iconLbl.TextColor3 = ACCENT
				end
				p.entry.BackgroundTransparency = 1
			else
				p.titleLbl.TextColor3 = Color3.fromRGB(205, 205, 205)
				if p.iconLbl then
					p.iconLbl.TextColor3 = Color3.fromRGB(170, 170, 170)
				end
				p.entry.BackgroundTransparency = 1
			end
		end
		return true
	end
	function self:SetOpen(v)
		self.open = v ~= false
		gui.Enabled = self.open
		return self.open
	end
	function self:Toggle()
		return self:SetOpen(not self.open)
	end
	function self:Destroy()
		pcall(function() gui:Destroy() end)
		self.pages = {}
		self.order = {}
		self.current = nil
	end
	table.insert(self.connections, UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == self.toggleKey then
			self:SetOpen(not self.open)
		end
	end))
	main:GetPropertyChangedSignal("Position"):Connect(function()
		for _, p in ipairs(self.order) do
			if p.panel then
				local cur = p.panel.Position
				p.panel.Position = UDim2.new(cur.X.Scale, cur.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset)
			end
		end
	end)
	return self
end
return UILib
