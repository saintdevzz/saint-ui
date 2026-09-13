local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local HEADER_HEIGHT = 56
local SIDEBAR_WIDTH = 176
local SIDE = 12
local BOTTOM = 12
local GAP = 10
local ROW_HEIGHT = 44
local ROW_TALL = 62
local RADIUS = 8
local CONTENT_TOP = HEADER_HEIGHT + GAP

local family = "rbxasset://fonts/families/GothamSSm.json"

local theme = {
	Window = Color3.fromRGB(10, 10, 10),
	Panel = Color3.fromRGB(15, 15, 15),
	Control = Color3.fromRGB(20, 20, 20),
	Hover = Color3.fromRGB(31, 31, 31),
	Divider = Color3.fromRGB(31, 31, 31),
	Track = Color3.fromRGB(53, 53, 53),
	Accent = Color3.fromRGB(237, 237, 237),
	Text = Color3.fromRGB(255, 255, 255),
	TextSoft = Color3.fromRGB(217, 217, 217),
	TextDim = Color3.fromRGB(140, 140, 140),
	Stroke = Color3.fromRGB(181, 181, 181),
	NavActive = Color3.fromRGB(46, 46, 46),
	Icon = Color3.fromRGB(120, 120, 120),
	IconActive = Color3.fromRGB(255, 255, 255),
	Font = Font.new(family, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
	FontRegular = Font.new(family, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	FontBold = Font.new(family, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
}

local UILib = {}
UILib.Theme = theme

local Window = {}
Window.__index = Window

local Host = {}
Host.__index = Host

local Page = setmetatable({}, { __index = Host })
Page.__index = Page

local Module = setmetatable({}, { __index = Host })
Module.__index = Module

local function create(class, properties, parent)
	local instance = Instance.new(class)
	for key, value in pairs(properties or {}) do
		instance[key] = value
	end
	if parent then
		instance.Parent = parent
	end
	return instance
end

local function round(parent, radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius or RADIUS) }, parent)
end

local function stroke(parent, color, thickness)
	return create("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = color,
		Thickness = thickness or 1,
	}, parent)
end

local function tween(instance, properties, time, style, direction)
	local animation = TweenService:Create(
		instance,
		TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
		properties
	)
	animation:Play()
	return animation
end

local function object(instance)
	local wrapper = { instance = instance }
	wrapper.Destroy = function()
		instance:Destroy()
	end
	return wrapper
end

local function line(parent, x1, y1, x2, y2, thickness, color)
	local dx = x2 - x1
	local dy = y2 - y1
	return create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
		Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), thickness or 1.4),
		Rotation = math.deg(math.atan2(dy, dx)),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
	}, parent)
end

local function chevron(parent, color)
	line(parent, 3.5, 6, 8, 10.5, 1.4, color)
	line(parent, 8, 10.5, 12.5, 6, 1.4, color)
end

local function caret(parent, color, direction)
	if direction == "up" then
		line(parent, 3.5, 10, 8, 5.5, 1.4, color)
		line(parent, 8, 5.5, 12.5, 10, 1.4, color)
	else
		line(parent, 3.5, 6, 8, 10.5, 1.4, color)
		line(parent, 8, 10.5, 12.5, 6, 1.4, color)
	end
end

local function dots(parent, color)
	local holder = create("Frame", {
		Name = "Dots",
		Size = UDim2.fromOffset(4, 16),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
	}, parent)
	for index = 0, 2 do
		local dot = create("Frame", {
			Name = "Dot",
			Size = UDim2.fromOffset(4, 4),
			Position = UDim2.fromOffset(0, index * 6),
			BackgroundColor3 = color,
			BorderSizePixel = 0,
		}, holder)
		round(dot, 2)
	end
	return holder
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

local function buildIcon(parent, value, color, size)
	local asset = assetId(value)
	if not asset then
		return nil
	end

	local holder = create("Frame", {
		Name = "Icon",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size or 16, size or 16),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	}, parent)

	create("ImageLabel", {
		Name = "Glyph",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = asset,
		ImageColor3 = color,
		ScaleType = Enum.ScaleType.Fit,
	}, holder)

	return holder
end

local function tint(holder, color, time)
	for _, descendant in ipairs(holder:GetDescendants()) do
		if descendant:IsA("UIStroke") then
			tween(descendant, { Color = color }, time)
		elseif descendant:IsA("Frame") then
			tween(descendant, { BackgroundColor3 = color }, time)
		elseif descendant:IsA("ImageLabel") then
			tween(descendant, { ImageColor3 = color }, time)
		elseif descendant:IsA("TextLabel") then
			tween(descendant, { TextColor3 = color }, time)
		end
	end
end

local function screenBox(anchor)
	local parent = anchor.Parent
	while parent and parent.ClassName ~= "ScreenGui" do
		parent = parent.Parent
	end
	return parent
end

local function placeFloating(overlay, anchor, frame, width, height)
	local originX = overlay.AbsolutePosition.X
	local originY = overlay.AbsolutePosition.Y
	local screenX = overlay.AbsoluteSize.X
	local screenY = overlay.AbsoluteSize.Y

	local anchorX = anchor.AbsolutePosition.X - originX
	local anchorY = anchor.AbsolutePosition.Y - originY
	local anchorW = anchor.AbsoluteSize.X
	local anchorH = anchor.AbsoluteSize.Y

	local x = anchorX + anchorW - width
	if x < 6 then
		x = 6
	end
	if screenX > width + 12 then
		x = math.min(x, screenX - width - 6)
	end

	local y = anchorY + anchorH + 6
	if screenY > height + 12 and y + height > screenY - 6 then
		local above = anchorY - height - 6
		if above > 6 then
			y = above
		else
			y = math.max(6, screenY - height - 6)
		end
	end

	frame.Position = UDim2.fromOffset(math.floor(x + 0.5), math.floor(y + 0.5))
end

function UILib:Window(config)
	local config = config or {}
	local window = setmetatable({}, Window)

	window.pages = {}
	window.rows = {}
	window.connections = {}
	window.open = true
	window.closing = false
	window.size = config.size or UDim2.fromOffset(700, 460)
	window.toggleKey = config.toggleKey == nil and Enum.KeyCode.RightShift or config.toggleKey

	local root = config.parent or LocalPlayer:WaitForChild("PlayerGui")

	local gui = create("ScreenGui", {
		Name = config.name or "UILib",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = config.displayOrder or 100,
		Enabled = true,
	}, root)

	local overlay = create("Frame", {
		Name = "Overlay",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = 50,
	}, gui)

	local main = create("Frame", {
		Name = "Main",
		Size = window.size,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(config.position or 0.5, config.position or 0.5),
		BackgroundColor3 = theme.Window,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, gui)
	local shape = round(main, 12)
	shape.Name = "Shape"

	create("Frame", {
		Name = "Separator",
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, HEADER_HEIGHT - 1),
		BackgroundColor3 = theme.Divider,
		BorderSizePixel = 0,
		ZIndex = 3,
	}, main)

	create("Frame", {
		Name = "SideSeparator",
		Size = UDim2.new(0, 1, 1, -(HEADER_HEIGHT + BOTTOM + 10)),
		Position = UDim2.fromOffset(SIDEBAR_WIDTH, HEADER_HEIGHT + 10),
		BackgroundColor3 = theme.Divider,
		BorderSizePixel = 0,
	}, main)

	local header = create("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		BackgroundTransparency = 1,
		ZIndex = 3,
	}, main)

	local logoWidth = 0
	local logoAsset = assetId(config.logo)
	if logoAsset then
		logoWidth = 36
		local holder = create("Frame", {
			Name = "Logo",
			Size = UDim2.fromOffset(26, 26),
			Position = UDim2.fromOffset(16, 15),
			BackgroundTransparency = 1,
		}, header)
		buildIcon(holder, logoAsset, theme.Text, 26)
	end

	local title = create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -(140 + logoWidth), 0, 18),
		Position = UDim2.fromOffset(16 + logoWidth, 11),
		BackgroundTransparency = 1,
		FontFace = theme.Font,
		TextSize = 17,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.title or "Saint",
	}, header)

	local subtitle = create("TextLabel", {
		Name = "Subtitle",
		Size = UDim2.new(1, -(140 + logoWidth), 0, 14),
		Position = UDim2.fromOffset(16 + logoWidth, 31),
		BackgroundTransparency = 1,
		FontFace = theme.FontRegular,
		TextSize = 12,
		TextColor3 = theme.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.subtitle or config.version or "v0.0.1",
	}, header)

	local controls = create("Frame", {
		Name = "Controls",
		Size = UDim2.fromOffset(66, 28),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
	}, header)
	round(controls, 8)

	local minimize = create("TextButton", {
		Name = "Minimize",
		Size = UDim2.fromOffset(28, 22),
		Position = UDim2.fromOffset(5, 3),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		FontFace = theme.Font,
		TextSize = 14,
		TextColor3 = theme.Text,
		Text = "-",
	}, controls)
	round(minimize, 6)

	local close = create("TextButton", {
		Name = "Close",
		Size = UDim2.fromOffset(28, 22),
		Position = UDim2.fromOffset(34, 3),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		FontFace = theme.Font,
		TextSize = 14,
		TextColor3 = theme.Text,
		Text = "X",
	}, controls)
	round(close, 6)

	for _, button in ipairs({ minimize, close }) do
		button.MouseEnter:Connect(function()
			tween(button, { BackgroundColor3 = theme.Hover }, 0.15)
		end)
		button.MouseLeave:Connect(function()
			tween(button, { BackgroundColor3 = theme.Control }, 0.15)
		end)
	end

	local sidebar = create("ScrollingFrame", {
		Name = "Sidebar",
		Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -(HEADER_HEIGHT + BOTTOM)),
		Position = UDim2.fromOffset(0, HEADER_HEIGHT),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70),
		ScrollBarImageTransparency = 0.2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
	}, main)

	local sidebarHolder = create("Frame", {
		Name = "Holder",
		Size = UDim2.new(1, -3, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
	}, sidebar)

	create("UIPadding", {
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
	}, sidebarHolder)

	create("UIListLayout", {
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, sidebarHolder)

	local content = create("Frame", {
		Name = "Content",
		Size = UDim2.new(1, -(SIDEBAR_WIDTH + GAP + SIDE), 1, -(CONTENT_TOP + BOTTOM)),
		Position = UDim2.new(0, SIDEBAR_WIDTH + GAP, 0, CONTENT_TOP),
		BackgroundTransparency = 1,
	}, main)

	window.gui = gui
	window.main = main
	window.overlay = overlay
	window.header = header
	window.title = title
	window.subtitle = subtitle
	window.controls = controls
	window.sidebar = sidebar
	window.sidebarHolder = sidebarHolder
	window.content = content

	local dragging = false
	local dragInput
	local dragOrigin

	local function hits(input, guiObject, padding)
		local position = guiObject.AbsolutePosition
		local size = guiObject.AbsoluteSize
		local margin = padding or 0
		return input.Position.X >= position.X - margin
			and input.Position.X <= position.X + size.X + margin
			and input.Position.Y >= position.Y - margin
			and input.Position.Y <= position.Y + size.Y + margin
	end

	table.insert(window.connections, UserInputService.InputBegan:Connect(function(input)
		if window.toggleKey and input.UserInputType == Enum.UserInputType.Keyboard
			and input.KeyCode == window.toggleKey and not window.toggleLocked and not window.closing then
			window:SetOpen(not window.open)
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if not hits(input, header) then
			return
		end
		if hits(input, controls, 8) then
			return
		end
		dragging = true
		dragInput = input.Position
		dragOrigin = main.Position
	end))

	table.insert(window.connections, UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local delta = input.Position - dragInput
		main.Position = UDim2.new(
			dragOrigin.X.Scale,
			dragOrigin.X.Offset + delta.X,
			dragOrigin.Y.Scale,
			dragOrigin.Y.Offset + delta.Y
		)
	end))

	table.insert(window.connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))

	minimize.MouseButton1Click:Connect(function()
		window:SetOpen(false)
	end)

	close.MouseButton1Click:Connect(function()
		window:Close()
	end)

	if config.page then
		window:Page(config.page, config.icon)
	end

	return window
end

function Window:SetToggleLocked(value)
	self.toggleLocked = value and true or false
	return self
end

function Window:SetOpen(value)
	local target = value ~= false
	if target == self.open then
		return self.open
	end
	self.open = target

	local full = self.size
	local collapsed = UDim2.new(full.X.Scale, full.X.Offset, 0, 0)

	if self.open then
		self.gui.Enabled = true
		self.main.Size = collapsed
		tween(self.main, {
			Size = UDim2.new(full.X.Scale, full.X.Offset, full.Y.Scale, full.Y.Offset),
		}, 0.28, Enum.EasingStyle.Quint)
		return self.open
	end

	self:CloseFloating()
	local shrinking = tween(self.main, { Size = collapsed }, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	shrinking.Completed:Connect(function()
		if not self.open then
			self.gui.Enabled = false
		end
	end)

	return self.open
end

function Window:IsOpen()
	return self.open
end

function Window:Toggle()
	return self:SetOpen(not self.open)
end

function Window:SetToggleKey(key)
	self.toggleKey = key
	return self
end

local function rowLabels(parent, config, width, description, fallback, inset, reserve)
	local margin = 14 + (inset or 0)
	local titleSize = math.max(60, width - margin - 20 - (reserve or 0))
	if config.titleWidth then
		titleSize = math.min(titleSize, config.titleWidth)
	end

	local title = create("TextLabel", {
		Name = "Title",
		Size = UDim2.fromOffset(titleSize, 16),
		Position = UDim2.fromOffset(margin, description and 11 or 14),
		AnchorPoint = Vector2.new(0, description and 0 or 0.5),
		BackgroundTransparency = 1,
		FontFace = config.bold and theme.FontBold or theme.Font,
		TextSize = 14,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Text = config.title or config.text or fallback,
	}, parent)

	local desc
	if description then
		desc = create("TextLabel", {
			Name = "Description",
			Size = UDim2.fromOffset(math.max(60, width - margin - 14), 28),
			Position = UDim2.fromOffset(margin, 30),
			BackgroundTransparency = 1,
			FontFace = theme.FontRegular,
			TextSize = 12,
			TextColor3 = theme.TextDim,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Text = description,
		}, parent)
	end

	return title, desc
end

local function panelRow(owner, config, order, name, reserve)
	local description = config.desc or config.description
	local height = description and ROW_TALL or ROW_HEIGHT

	local panel = create("Frame", {
		Name = config.name or name,
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		LayoutOrder = order,
	}, owner.box)
	round(panel, 8)

	local titleLabel, descriptionLabel = rowLabels(
		panel,
		config,
		owner.width,
		description,
		"Option",
		owner.inset,
		reserve
	)

	if owner.hover then
		panel.MouseEnter:Connect(function()
			tween(panel, { BackgroundColor3 = theme.Hover }, 0.15)
		end)
		panel.MouseLeave:Connect(function()
			tween(panel, { BackgroundColor3 = theme.Panel }, 0.15)
		end)
	end

	return panel, titleLabel, descriptionLabel
end

function Window:Page(name, icon)
	local index = #self.pages + 1

	local item = create("TextButton", {
		Name = name .. "Entry",
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = theme.Panel,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = index,
	}, self.sidebarHolder)
	round(item, 8)

	local entryIcon = buildIcon(item, icon, theme.Icon, 16)

	local entryLabel = create("TextLabel", {
		Name = "Label",
		Size = UDim2.new(1, -(28 + (entryIcon and 24 or 0)), 1, 0),
		Position = UDim2.fromOffset(14 + (entryIcon and 24 or 0), 0),
		BackgroundTransparency = 1,
		FontFace = theme.Font,
		TextSize = 14,
		TextColor3 = theme.TextSoft,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = name,
	}, item)

	local holder = create("Frame", {
		Name = name .. "Page",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
	}, self.content)

	local scroller = create("ScrollingFrame", {
		Name = "Scroller",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70),
		ScrollBarImageTransparency = 0.2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		ClipsDescendants = true,
	}, holder)

	local box = create("Frame", {
		Name = "Box",
		Size = UDim2.new(1, -3, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
	}, scroller)

	create("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, box)

	local page = setmetatable({
		rows = {},
		teardowns = {},
		floaters = {},
	}, Page)

	local available = self.content.AbsoluteSize.X

	page.window = self
	page.name = name
	page.item = item
	page.holder = holder
	page.scroller = scroller
	page.box = box
	page.entryIcon = entryIcon
	page.entryLabel = entryLabel
	page.order = 0
	page.inset = 0
	page.hover = true
	page.width = (available > 60) and (available - 2) or 470

	self.pages[name] = page
	self.pages[index] = page

	item.MouseEnter:Connect(function()
		if page.active then
			tween(item, { BackgroundColor3 = theme.Hover }, 0.15)
		else
			tween(item, { BackgroundColor3 = theme.Hover, BackgroundTransparency = 0 }, 0.15)
		end
	end)
	item.MouseLeave:Connect(function()
		if page.active then
			tween(item, { BackgroundColor3 = theme.NavActive }, 0.15)
		else
			tween(item, { BackgroundTransparency = 1 }, 0.15)
		end
	end)
	item.MouseButton1Click:Connect(function()
		self:Select(name)
	end)

	if #self.pages == 1 then
		self:Select(name)
	end

	return page
end

function Window:Select(name)
	local target = self.pages[name]
	if not target then
		return false
	end

	self:CloseFloating()

	for _, page in ipairs(self.pages) do
		local active = page == target
		page.holder.Visible = active
		page.active = active
		if page.entryIcon then
			tint(page.entryIcon, active and theme.IconActive or theme.Icon, 0.18)
		end
		tween(page.entryLabel, { TextColor3 = active and theme.Text or theme.TextSoft }, 0.18)
		tween(page.item, {
			BackgroundTransparency = active and 0 or 1,
			BackgroundColor3 = active and theme.NavActive or theme.Panel,
		}, 0.18)
	end

	self.current = target
	return true
end

function Window:PageNames()
	local names = {}
	for _, page in ipairs(self.pages) do
		table.insert(names, page.name)
	end
	return names
end

function Window:CloseFloating()
	for _, page in ipairs(self.pages) do
		page:CloseFloating()
	end
end

function Window:SetTitle(text)
	self.title.Text = text
	return self
end

function Window:SetSubtitle(text)
	self.subtitle.Text = text
	return self
end

function Window:SetSize(size)
	self.size = size
	self.main.Size = size
	return self
end

function Window:Minimize()
	return self:SetOpen(false)
end

function Window:Destroy()
	self.closing = true

	for _, page in ipairs(self.pages) do
		page:Teardown()
	end

	for _, connection in ipairs(self.connections) do
		connection:Disconnect()
	end

	self.pages = {}
	self.connections = {}
	self.main:Destroy()
	self.gui:Destroy()

	return true
end

function Window:Close()
	if self.closing then
		return
	end

	self:CloseFloating()
	self.closing = true
	self.open = false

	local closing = tween(self.main, {
		Size = UDim2.new(self.main.Size.X.Scale, self.main.Size.X.Offset, 0, 0),
	}, 0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	closing.Completed:Connect(function()
		self:Destroy()
	end)

	return true
end

function Host:Register(teardown)
	table.insert(self.teardowns, teardown)
end

function Host:RegisterFloating(close)
	table.insert(self.floaters, close)
end

function Host:CloseFloating()
	for _, close in ipairs(self.floaters) do
		close()
	end
	self.floaters = {}
end

function Host:Teardown()
	for _, teardown in ipairs(self.teardowns) do
		teardown()
	end
	self.teardowns = {}
	self.floaters = {}
end

function Host:Next()
	self.order = self.order + 1
	return self.order
end

function Host:Row(config, order, name, reserve)
	return panelRow(self, config, order, name, reserve)
end

function Page:Open()
	self.window:SetOpen(true)
	return self
end

function Page:Module(config)
	local config = type(config) == "string" and { title = config } or (config or {})
	local order = self:Next()
	local header, titleLabel = panelRow(self, config, order, config.name or "Module", 34)

	local arrow = create("Frame", {
		Name = "Arrow",
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		BackgroundTransparency = 1,
	}, header)
	local caretHolder = create("Frame", {
		Name = "Caret",
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,
	}, arrow)
	caret(caretHolder, theme.TextDim, "down")

	local children = create("Frame", {
		Name = "Children",
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.None,
		LayoutOrder = order + 1,
		Visible = false,
	}, self.box)


	create("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, children)

	local module = setmetatable({
		teardowns = {},
		floaters = {},
	}, Module)

	module.window = self.window
	module.page = self
	module.name = config.title or name
	module.box = children
	module.header = header
	module.arrow = arrow
	module.caret = caretHolder
	module.label = titleLabel
	module.order = 0
	module.inset = 14
	module.hover = true
	module.width = math.max(180, self.width - 14)
	module.open = false

	local toggle = create("TextButton", {
		Name = "Expand",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		ZIndex = 4,
	}, header)
	module.toggle = toggle

	toggle.MouseButton1Click:Connect(function()
		module:SetOpen(not module.open)
	end)

	self.order = math.max(self.order, order + 1)
	table.insert(self.rows, module)
	if config.open then
		module:SetOpen(true)
	end
	return module
end

function Module:SetOpen(value)
	local target = value ~= false
	if target == self.open then
		return self.open
	end
	self.open = target

	self.box.Visible = target
	self.box.AutomaticSize = target and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
	self.box.Size = target and UDim2.new(1, 0, 0, 0) or UDim2.new(1, 0, 0, 0)
	self.caret.Rotation = target and 180 or 0
	tween(self.header, { BackgroundColor3 = target and theme.Hover or theme.Panel }, 0.18)

	return self.open
end

function Module:Open()
	return self:SetOpen(true)
end

function Module:Close()
	return self:SetOpen(false)
end

function Module:IsOpen()
	return self.open
end

function Module:Destroy()
	self:CloseFloating()
	for _, teardown in ipairs(self.teardowns) do
		teardown()
	end
	self.teardowns = {}
	self.floaters = {}
	self.header:Destroy()
	self.box:Destroy()
	return true
end
function Host:Group(text)
	local config = type(text) == "table" and text or { text = text }
	local inset = 14 + (self.inset or 0)
	local wrapper = create("Frame", {
		Name = "Group",
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		LayoutOrder = self:Next(),
	}, self.box)
	local label = create("TextLabel", {
		Name = "Text",
		Size = UDim2.new(1, -inset, 0, 22),
		Position = UDim2.fromOffset(inset, 8),
		BackgroundTransparency = 1,
		FontFace = theme.FontBold,
		TextSize = 11,
		TextColor3 = theme.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = string.upper(tostring(config.text or config.title or "Group")),
	}, wrapper)

	local api = object(wrapper)
	function api:SetText(value)
		label.Text = string.upper(tostring(value or ""))
	end
	return api
end

function Host:Label(text)
	local config = type(text) == "table" and text or { text = text }
	local inset = 14 + (self.inset or 0)
	local wrapper = create("Frame", {
		Name = "Label",
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = self:Next(),
	}, self.box)

	local label = create("TextLabel", {
		Name = "Text",
		Size = UDim2.new(1, -(inset + 14), 1, 0),
		Position = UDim2.fromOffset(inset, 0),
		BackgroundTransparency = 1,
		FontFace = theme.FontRegular,
		TextSize = 13,
		TextColor3 = theme.TextSoft,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = true,
		Text = config.text or config.title or "",
	}, wrapper)

	local api = object(wrapper)
	function api:SetText(value)
		label.Text = tostring(value or "")
	end
	return api
end

function Host:Divider()
	local wrapper = create("Frame", {
		Name = "Divider",
		Size = UDim2.new(1, 0, 0, 17),
		BackgroundTransparency = 1,
		LayoutOrder = self:Next(),
	}, self.box)
	create("Frame", {
		Name = "Line",
		Size = UDim2.new(1, -(28 + 2 * (self.inset or 0)), 0, 1),
		Position = UDim2.fromOffset(14 + (self.inset or 0), 8),
		BackgroundColor3 = theme.Divider,
		BorderSizePixel = 0,
	}, wrapper)
	return object(wrapper)
end

function Host:Button(config)
	local config = config or {}
	local callback = config.callback
	local order = self:Next()
	local panel, title = panelRow(self, config, order, "Button", 116)

	local pill = create("Frame", {
		Name = "Pill",
		Size = UDim2.fromOffset(96, 30),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
	}, panel)
	round(pill, 10)

	local pillText = create("TextLabel", {
		Name = "Label",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		FontFace = theme.Font,
		TextSize = 13,
		TextColor3 = theme.TextSoft,
		Text = config.button or config.text or "Run",
	}, pill)

	local click = create("TextButton", {
		Name = "Click",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		ZIndex = 5,
	}, pill)

	click.MouseEnter:Connect(function()
		tween(pill, { Size = UDim2.fromOffset(104, 34) }, 0.18)
		tween(pill, { BackgroundColor3 = theme.Accent }, 0.18)
		tween(pillText, { TextColor3 = Color3.fromRGB(0, 0, 0) }, 0.18)
	end)

	click.MouseLeave:Connect(function()
		tween(pill, { Size = UDim2.fromOffset(96, 30) }, 0.18)
		tween(pill, { BackgroundColor3 = theme.Control }, 0.18)
		tween(pillText, { TextColor3 = theme.TextSoft }, 0.18)
	end)

	click.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	local wrapper = object(panel)
	function wrapper:SetTitle(value)
		title.Text = tostring(value or "")
	end
	function wrapper:SetButton(value)
		pillText.Text = tostring(value or "")
	end
	function wrapper:GetButton()
		return pillText.Text
	end
	function wrapper:SetCallback(value)
		callback = value
	end
	function wrapper:Click()
		if callback then
			callback()
		end
	end
	return wrapper
end

function Host:Toggle(config)
	local config = config or {}
	local value = config.value == true
	local callback = config.callback
	local order = self:Next()
	local panel, title = panelRow(self, config, order, "Toggle", 74)

	local track = create("TextButton", {
		Name = "Switch",
		Size = UDim2.fromOffset(46, 24),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, panel)
	round(track, 12)

	local knob = create("Frame", {
		Name = "Knob",
		Size = UDim2.fromOffset(16, 16),
		Position = UDim2.fromOffset(4, 4),
		BackgroundColor3 = theme.TextDim,
		BorderSizePixel = 0,
	}, track)
	round(knob, 8)

	local function render(state, animate)
		local offset = state and 26 or 4
		local trackColor = state and theme.Accent or theme.Control
		local knobColor = state and Color3.fromRGB(0, 0, 0) or theme.TextDim

		if animate then
			tween(track, { BackgroundColor3 = trackColor }, 0.2)
			tween(knob, { BackgroundColor3 = knobColor }, 0.2)
			tween(knob, { Position = UDim2.fromOffset(offset, 4) }, 0.22, Enum.EasingStyle.Quint)
		else
			track.BackgroundColor3 = trackColor
			knob.BackgroundColor3 = knobColor
			knob.Position = UDim2.fromOffset(offset, 4)
		end
	end

	local function flip()
		value = not value
		render(value, true)
		if callback then
			callback(value)
		end
	end

	track.MouseButton1Click:Connect(flip)
	render(value, false)

	local wrapper = object(panel)
	function wrapper:SetValue(state)
		value = state == true
		render(value, true)
	end
	function wrapper:GetValue()
		return value
	end
	function wrapper:Toggle()
		flip()
	end
	function wrapper:SetCallback(next)
		callback = next
	end
	return wrapper
end

function Host:Slider(config)
	local config = config or {}
	local min = config.min or 0
	local max = config.max or 100
	local decimals = config.decimals or 0
	local callback = config.callback
	local suffix = config.suffix or ""
	local value = min

	local order = self:Next()
	local description = config.desc or config.description
	local height = (description and ROW_TALL or ROW_HEIGHT) + 26
	local panel = create("Frame", {
		Name = config.name or "Slider",
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		LayoutOrder = order,
	}, self.box)
	round(panel, 8)

	rowLabels(panel, config, self.width, description, "Value", self.inset, 90)

	local readout = create("TextLabel", {
		Name = "Readout",
		Size = UDim2.fromOffset(90, 16),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -14, 0, 12),
		BackgroundTransparency = 1,
		FontFace = theme.Font,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Right,
		Text = "",
	}, panel)

	local trackY = description and 44 or 32

	local track = create("Frame", {
		Name = "Track",
		Size = UDim2.new(1, -28, 0, 6),
		Position = UDim2.fromOffset(14, trackY),
		BackgroundColor3 = theme.Track,
		BorderSizePixel = 0,
	}, panel)
	round(track, 3)

	local fill = create("Frame", {
		Name = "Fill",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
	}, track)
	round(fill, 3)

	local knob = create("Frame", {
		Name = "Knob",
		Size = UDim2.fromOffset(18, 18),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 3,
	}, track)
	round(knob, 9)

	local hit = create("TextButton", {
		Name = "Hit",
		Size = UDim2.new(1, -20, 0, 30),
		Position = UDim2.fromOffset(10, trackY - 12),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		ZIndex = 4,
	}, panel)

	local function format(number)
		if decimals > 0 then
			return string.format("%." .. decimals .. "f", number)
		end
		return tostring(math.floor(number + 0.5))
	end

	local range = (max - min) ~= 0 and (max - min) or 1

	local function render(fraction, fire)
		knob.Position = UDim2.new(fraction, 0, 0.5, 0)
		fill.Size = UDim2.new(fraction, 0, 1, 0)
		readout.Text = format(value) .. suffix
		if fire and callback then
			callback(value)
		end
	end

	local function apply(fraction, fire)
		local clamped = math.clamp(fraction, 0, 1)
		local raw = min + range * clamped
		if decimals > 0 then
			local scale = 10 ^ decimals
			raw = math.floor(raw * scale + 0.5) / scale
		else
			raw = math.floor(raw + 0.5)
		end
		value = math.clamp(raw, min, max)
		render((value - min) / range, fire)
	end

	local dragging = false
	local connections = {}

	local function fractionOf(input)
		local position = track.AbsolutePosition
		local size = track.AbsoluteSize
		if size.X <= 0 then
			return 0
		end
		return (input.Position.X - position.X) / size.X
	end

	hit.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		dragging = true
		apply(fractionOf(input), true)
	end)

	table.insert(connections, UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		apply(fractionOf(input), true)
	end))

	table.insert(connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))

	apply(((config.value or min) - min) / range, false)

	local wrapper = object(panel)
	function wrapper:SetValue(number)
		apply(((number or min) - min) / range, false)
	end
	function wrapper:GetValue()
		return value
	end
	function wrapper:SetCallback(next)
		callback = next
	end

	local function release()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		connections = {}
	end

	self:Register(release)
	wrapper.Destroy = function()
		release()
		panel:Destroy()
	end
	return wrapper
end

function Host:TextBox(config)
	local config = config or {}
	local callback = config.callback
	local order = self:Next()
	local panel, title = panelRow(self, config, order, "TextBox", 214)

	local input = create("TextBox", {
		Name = "Input",
		Size = UDim2.fromOffset(196, 28),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		FontFace = theme.FontRegular,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		PlaceholderText = config.placeholder or "Type here...",
		PlaceholderColor3 = theme.TextDim,
		ClearTextOnFocus = false,
		Text = config.text or "",
	}, panel)
	round(input, 8)

	create("UIPadding", {
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
	}, input)

	local outline = stroke(input, theme.Control, 1)

	input.Focused:Connect(function()
		tween(outline, { Color = theme.Stroke }, 0.15)
	end)

	input.FocusLost:Connect(function(enterPressed)
		tween(outline, { Color = theme.Control }, 0.15)
		if callback then
			callback(input.Text, enterPressed)
		end
	end)

	local wrapper = object(panel)
	function wrapper:SetText(text)
		input.Text = tostring(text or "")
	end
	function wrapper:GetText()
		return input.Text
	end
	function wrapper:SetPlaceholder(text)
		input.PlaceholderText = tostring(text or "")
	end
	function wrapper:SetCallback(next)
		callback = next
	end
	return wrapper
end

function Host:Keybind(config)
	local config = config or {}
	local callback = config.callback
	local key = config.key
	local mode = config.mode or "toggle"
	local pressed = false
	local listening = false
	local connections = {}

	if key == Enum.KeyCode.Unknown then
		key = nil
	end

	local order = self:Next()
	local panel, title = panelRow(self, config, order, "Keybind", 140)

	local button = create("TextButton", {
		Name = "Bind",
		Size = UDim2.fromOffset(120, 28),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		FontFace = theme.Font,
		TextSize = 13,
		TextColor3 = theme.TextSoft,
		Text = key and key.Name or "None",
	}, panel)
	round(button, 8)

	local function isMouse(input)
		return input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.MouseButton2
			or input.UserInputType == Enum.UserInputType.MouseButton3
	end

	local function refresh()
		button.Text = key and (key.Name or tostring(key)) or "None"
	end

	local function fire()
		if not callback then
			return
		end
		if mode == "toggle" then
			pressed = not pressed
			callback(pressed)
		else
			callback(key)
		end
	end

	table.insert(connections, UserInputService.InputBegan:Connect(function(input)
		if listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Unknown then
					return
				end
				key = input.KeyCode
			elseif isMouse(input) then
				key = input.UserInputType
			else
				return
			end
			listening = false
			button.TextColor3 = theme.Text
			refresh()
			return
		end

		if pressed and input.KeyCode == Enum.KeyCode.Unknown and not isMouse(input) then
			return
		end

		if not key or input.KeyCode == nil then
			return
		end

		local matches
		if typeof(key) == "EnumUserInputType" then
			matches = input.UserInputType == key
		else
			matches = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key
		end

		if matches then
			fire()
		end
	end))

	table.insert(connections, UserInputService.InputEnded:Connect(function(input)
		if mode ~= "hold" or not key then
			return
		end
		local matches
		if typeof(key) == "EnumUserInputType" then
			matches = input.UserInputType == key
		else
			matches = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key
		end
		if matches then
			pressed = false
			if callback then
				callback(false)
			end
		end
	end))

	button.MouseEnter:Connect(function()
		if not listening then
			tween(button, { BackgroundColor3 = theme.Hover }, 0.15)
		end
	end)

	button.MouseLeave:Connect(function()
		if not listening then
			tween(button, { BackgroundColor3 = theme.Control }, 0.15)
		end
	end)

	button.MouseButton1Click:Connect(function()
		if listening then
			return
		end
		listening = true
		pressed = false
		button.Text = "Press a key..."
		button.TextColor3 = theme.TextDim
	end)

	local wrapper = object(panel)
	function wrapper:SetKey(value)
		if value == Enum.KeyCode.Unknown then
			value = nil
		end
		key = value
		button.TextColor3 = theme.TextSoft
		refresh()
	end
	function wrapper:GetKey()
		return key
	end
	function wrapper:SetCallback(next)
		callback = next
	end

	local function release()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		connections = {}
	end

	self:Register(release)
	wrapper.Destroy = function()
		release()
		panel:Destroy()
	end
	return wrapper
end

function Host:Dropdown(config)
	local config = config or {}
	local host = self
	local options = config.options or {}
	local callback = config.callback
	local selected = config.default
	local expanded = false
	local width = config.width or 196

	local order = self:Next()
	local panel, title = panelRow(self, config, order, "Dropdown", width + 40)

	local shell = create("TextButton", {
		Name = "Shell",
		Size = UDim2.fromOffset(width, 30),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, panel)
	round(shell, 8)

	local label = create("TextLabel", {
		Name = "Label",
		Size = UDim2.new(1, -38, 1, 0),
		Position = UDim2.fromOffset(14, 0),
		BackgroundTransparency = 1,
		FontFace = theme.Font,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = "",
	}, shell)

	local function paintLabel()
		if selected ~= nil then
			label.Text = tostring(selected)
			label.TextColor3 = theme.Text
		else
			label.Text = tostring(config.placeholder or "Select...")
			label.TextColor3 = theme.TextDim
		end
	end

	paintLabel()

	local arrow = create("Frame", {
		Name = "Chevron",
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		BackgroundTransparency = 1,
	}, shell)
	local caretHolder = create("Frame", {
		Name = "Caret",
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,
	}, arrow)
	caret(caretHolder, theme.TextDim, "down")

	local list = create("Frame", {
		Name = "List",
		Size = UDim2.fromOffset(width, 0),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 60,
	}, self.window.overlay)
	round(list, 10)

	local scroll = create("ScrollingFrame", {
		Name = "Scroll",
		Size = UDim2.new(1, -10, 1, -10),
		Position = UDim2.fromOffset(5, 5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70),
		ScrollBarImageTransparency = 0.2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		ZIndex = 61,
	}, list)

	local optionsHolder = create("Frame", {
		Name = "Holder",
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 61,
	}, scroll)

	create("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, optionsHolder)

	local entries = {}

	local function shownHeight()
		local visible = math.min(#options, 5)
		if visible == 0 then
			return 12
		end
		return visible * 32 + math.max(visible - 1, 0) * 4 + 10
	end

	local function place()
		placeFloating(self.window.overlay, shell, list, width, shownHeight())
	end

	local function close(animate)
		if not expanded then
			return
		end
		expanded = false
		if animate then
			local shrinking = tween(list, { Size = UDim2.fromOffset(width, 0) }, 0.18)
			tween(caretHolder, { Rotation = 0 }, 0.18)
			shrinking.Completed:Connect(function()
				if not expanded then
					list.Visible = false
				end
			end)
		else
			list.Size = UDim2.fromOffset(width, 0)
			caretHolder.Rotation = 0
			list.Visible = false
		end
	end

	local function refresh()
		for _, entry in ipairs(entries) do
			entry:Destroy()
		end
		entries = {}

		for index, option in ipairs(options) do
			local entry = create("TextButton", {
				Name = "Option",
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = theme.Control,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				FontFace = theme.FontRegular,
				TextSize = 13,
				TextColor3 = option == selected and theme.Text or theme.TextSoft,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = tostring(option),
				LayoutOrder = index,
				ZIndex = 61,
			}, optionsHolder)
			round(entry, 6)
			create("UIPadding", { PaddingLeft = UDim.new(0, 12) }, entry)

			entry.MouseEnter:Connect(function()
				tween(entry, { BackgroundColor3 = theme.Hover }, 0.12)
			end)

			entry.MouseLeave:Connect(function()
				tween(entry, { BackgroundColor3 = theme.Control }, 0.12)
			end)

			entry.MouseButton1Click:Connect(function()
				selected = option
				paintLabel()
				for _, other in ipairs(entries) do
					other.TextColor3 = theme.TextSoft
				end
				entry.TextColor3 = theme.Text
				close(true)
				if callback then
					callback(option)
				end
			end)

			table.insert(entries, entry)
		end
	end

	shell.MouseEnter:Connect(function()
		tween(shell, { BackgroundColor3 = theme.Hover }, 0.15)
	end)

	shell.MouseLeave:Connect(function()
		tween(shell, { BackgroundColor3 = theme.Control }, 0.15)
	end)

	shell.MouseButton1Click:Connect(function()
		if expanded then
			close(true)
		else
			host.window:CloseFloating()
			expanded = true
			list.Visible = true
			place()
			list.Size = UDim2.fromOffset(width, 0)
			tween(list, { Size = UDim2.fromOffset(width, shownHeight()) }, 0.2)
			tween(caretHolder, { Rotation = 180 }, 0.2)
		end
	end)

	local follow = function()
		if expanded then
			place()
		end
	end

	local moveConnection = self.window.main:GetPropertyChangedSignal("AbsolutePosition"):Connect(follow)
	local hostScroller = host.scroller or host.window.current and host.window.current.scroller or host.window.main
	local scrollConnection = hostScroller:GetPropertyChangedSignal("CanvasPosition"):Connect(follow)

	self:Register(function()
		moveConnection:Disconnect()
		scrollConnection:Disconnect()
	end)

	self:RegisterFloating(function()
		close(false)
	end)

	self:Register(function()
		list:Destroy()
	end)

	refresh()

	local wrapper = object(panel)
	function wrapper:SetOptions(values)
		options = values or {}
		refresh()
		if expanded then
			list.Size = UDim2.fromOffset(width, shownHeight())
		end
	end
	function wrapper:GetOptions()
		return options
	end
	function wrapper:SetValue(value)
		selected = value
		paintLabel()
		refresh()
	end
	function wrapper:GetValue()
		return selected
	end
	function wrapper:Open()
		if expanded then
			return
		end
		host.window:CloseFloating()
		expanded = true
		list.Visible = true
		place()
		tween(list, { Size = UDim2.fromOffset(width, shownHeight()) }, 0.2)
		tween(caretHolder, { Rotation = 180 }, 0.2)
	end
	function wrapper:Close()
		close(true)
	end
	function wrapper:SetCallback(next)
		callback = next
	end
	return wrapper
end

function Page:Destroy()
	self:Teardown()
	self.item:Destroy()
	self.holder:Destroy()
	return true
end

return UILib
