local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local TITLE_HEIGHT = 58
local NAV_TOP = TITLE_HEIGHT
local NAV_HEIGHT = 35
local CONTENT_TOP = NAV_TOP + NAV_HEIGHT + 8
local CONTENT_TOP_PLAIN = TITLE_HEIGHT + 10
local SIDE = 12
local BOTTOM = 12

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
	Nav = Color3.fromRGB(31, 31, 31),
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

local Page = {}
Page.__index = Page

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
	return create("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
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
		TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
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

local Icons = {}

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

local function bar(parent, x, y, width, height, color)
	return create("Frame", {
		Position = UDim2.fromOffset(x, y),
		Size = UDim2.fromOffset(width, height),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
	}, parent)
end

local function dot(parent, x, y, size, color)
	local circle = bar(parent, x, y, size, size, color)
	round(circle, size)
	return circle
end

local function ring(parent, x, y, size, color, thickness)
	local circle = create("Frame", {
		Position = UDim2.fromOffset(x, y),
		Size = UDim2.fromOffset(size, size),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, parent)
	round(circle, size)
	stroke(circle, color, thickness or 1.4)
	return circle
end

Icons.home = function(parent, color)
	line(parent, 3, 7, 8, 1.5, 1.4, color)
	line(parent, 8, 1.5, 13, 7, 1.4, color)
	bar(parent, 3, 6.4, 1.4, 7, color)
	bar(parent, 11.6, 6.4, 1.4, 7, color)
	bar(parent, 3, 12, 10, 1.4, color)
	bar(parent, 6.8, 9, 2.4, 4.4, color)
end

Icons.settings = function(parent, color)
	bar(parent, 1.5, 3, 13, 1.4, color)
	bar(parent, 1.5, 7.3, 13, 1.4, color)
	bar(parent, 1.5, 11.6, 13, 1.4, color)
	dot(parent, 3, 2.3, 2.8, color)
	dot(parent, 9.4, 6.6, 2.8, color)
	dot(parent, 5.6, 10.9, 2.8, color)
end

Icons.user = function(parent, color)
	ring(parent, 5, 1.5, 6, color, 1.4)
	local body = bar(parent, 2, 9.5, 12, 5.5, color)
	round(body, 3)
end

Icons.code = function(parent, color)
	line(parent, 6, 4, 2.5, 8, 1.4, color)
	line(parent, 2.5, 8, 6, 12, 1.4, color)
	line(parent, 10, 4, 13.5, 8, 1.4, color)
	line(parent, 13.5, 8, 10, 12, 1.4, color)
	line(parent, 9.2, 3, 6.8, 13, 1.2, color)
end

Icons.list = function(parent, color)
	bar(parent, 2, 3, 12, 1.6, color)
	bar(parent, 2, 7.2, 12, 1.6, color)
	bar(parent, 2, 11.4, 12, 1.6, color)
end

Icons.star = function(parent, color)
	local points = {}
	for index = 1, 5 do
		local angle = math.rad(-90 + (index - 1) * 144)
		table.insert(points, Vector2.new(8 + math.cos(angle) * 6.2, 8 + math.sin(angle) * 6.2))
	end
	for index = 1, 5 do
		local first = points[index]
		local second = points[index % 5 + 1]
		line(parent, first.X, first.Y, second.X, second.Y, 1.2, color)
	end
end

Icons.shield = function(parent, color)
	line(parent, 8, 1.5, 13.5, 4.5, 1.4, color)
	line(parent, 13.5, 4.5, 12.5, 10.5, 1.4, color)
	line(parent, 12.5, 10.5, 8, 14.5, 1.4, color)
	line(parent, 8, 14.5, 3.5, 10.5, 1.4, color)
	line(parent, 3.5, 10.5, 2.5, 4.5, 1.4, color)
	line(parent, 2.5, 4.5, 8, 1.5, 1.4, color)
end

Icons.folder = function(parent, color)
	line(parent, 2, 13.5, 2, 4, 1.4, color)
	line(parent, 2, 4, 6, 4, 1.4, color)
	line(parent, 6, 4, 7.5, 6.5, 1.4, color)
	line(parent, 7.5, 6.5, 14, 6.5, 1.4, color)
	line(parent, 14, 6.5, 14, 13.5, 1.4, color)
	line(parent, 2, 13.5, 14, 13.5, 1.4, color)
end

Icons.search = function(parent, color)
	ring(parent, 1.5, 1.5, 10, color, 1.4)
	line(parent, 11, 11, 14.5, 14.5, 1.4, color)
end

Icons.power = function(parent, color)
	local previous
	for index = 0, 8 do
		local angle = math.rad(-60 + index * 37.5)
		local point = Vector2.new(8 + math.cos(angle) * 5.5, 8.5 + math.sin(angle) * 5.5)
		if previous then
			line(parent, previous.X, previous.Y, point.X, point.Y, 1.3, color)
		end
		previous = point
	end
	line(parent, 8, 1.5, 8, 8, 1.3, color)
end

Icons.chevron = function(parent, color)
	line(parent, 3.5, 6, 8, 10.5, 1.4, color)
	line(parent, 8, 10.5, 12.5, 6, 1.4, color)
end

UILib.Icons = Icons

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

local function buildIcon(parent, name, color, size)
	local holder = create("Frame", {
		Name = "Icon",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size or 16, size or 16),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	}, parent)

	local asset = assetId(name)

	if asset then
		create("ImageLabel", {
			Name = "Glyph",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = asset,
			ImageColor3 = color,
			ScaleType = Enum.ScaleType.Fit,
		}, holder)
	elseif Icons[name] then
		local canvas = create("Frame", {
			Name = "Glyph",
			Size = UDim2.fromOffset(16, 16),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
		}, holder)
		Icons[name](canvas, color)
	elseif name ~= nil and name ~= "" then
		create("TextLabel", {
			Name = "Glyph",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			FontFace = theme.FontBold,
			TextSize = size or 16,
			TextColor3 = color,
			Text = tostring(name),
		}, holder)
	end

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

function UILib:Window(config)
	local config = config or {}
	local window = setmetatable({}, Window)

	window.pages = {}
	window.tabs = {}
	window.connections = {}
	window.navEnabled = config.nav ~= false
	window.minimized = false
	window.closing = false
	window.size = config.size or UDim2.fromOffset(639, 441)

	local root = config.parent or LocalPlayer:WaitForChild("PlayerGui")

	local gui = create("ScreenGui", {
		Name = config.name or "UILib",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = config.displayOrder or 100,
	}, root)

	local main = create("Frame", {
		Name = "Main",
		Size = window.size,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(config.position or 0.5, config.position or 0.5),
		BackgroundColor3 = theme.Window,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, gui)
	local shape = round(main, 8)
	shape.Name = "Shape"

	local titlebar = create("Frame", {
		Name = "Titlebar",
		Size = UDim2.new(1, 0, 0, TITLE_HEIGHT),
		BackgroundTransparency = 1,
	}, main)

	create("Frame", {
		Name = "Separator",
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, TITLE_HEIGHT - 1),
		BackgroundColor3 = theme.Divider,
		BorderSizePixel = 0,
	}, main)

	local logoWidth = 0
	if config.logo ~= nil then
		logoWidth = 36
		local holder = create("Frame", {
			Name = "Logo",
			Size = UDim2.fromOffset(26, 26),
			Position = UDim2.fromOffset(14, 16),
			BackgroundTransparency = 1,
		}, titlebar)
		buildIcon(holder, config.logo, theme.Text, 26)
	end

	local title = create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -(140 + logoWidth), 0, 18),
		Position = UDim2.fromOffset(14 + logoWidth, 12),
		BackgroundTransparency = 1,
		FontFace = theme.Font,
		TextSize = 16,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.title or "Saint",
	}, titlebar)

	local subtitle = create("TextLabel", {
		Name = "Subtitle",
		Size = UDim2.new(1, -(140 + logoWidth), 0, 14),
		Position = UDim2.fromOffset(14 + logoWidth, 31),
		BackgroundTransparency = 1,
		FontFace = theme.FontRegular,
		TextSize = 12,
		TextColor3 = theme.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.subtitle or "v0.0.1",
	}, titlebar)

	local controls = create("Frame", {
		Name = "Controls",
		Size = UDim2.fromOffset(58, 26),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
	}, titlebar)
	round(controls, 6)

	local minimize = create("TextButton", {
		Name = "Minimize",
		Size = UDim2.fromOffset(21, 20),
		Position = UDim2.fromOffset(5, 3),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		FontFace = theme.Font,
		TextSize = 14,
		TextColor3 = theme.Text,
		Text = "-",
	}, controls)
	round(minimize, 5)

	local close = create("TextButton", {
		Name = "Close",
		Size = UDim2.fromOffset(21, 20),
		Position = UDim2.fromOffset(32, 3),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		FontFace = theme.Font,
		TextSize = 14,
		TextColor3 = theme.Text,
		Text = "X",
	}, controls)
	round(close, 5)

	for _, button in ipairs({ minimize, close }) do
		button.MouseEnter:Connect(function()
			tween(button, { BackgroundColor3 = theme.Hover }, 0.15)
		end)
		button.MouseLeave:Connect(function()
			tween(button, { BackgroundColor3 = theme.Control }, 0.15)
		end)
	end

	local navbar = create("Frame", {
		Name = "Nav",
		Size = UDim2.new(0, 0, 0, NAV_HEIGHT),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, NAV_TOP),
		BackgroundColor3 = theme.Nav,
		BorderSizePixel = 0,
	}, main)

	local navbarShape = round(navbar, 8)
	navbarShape.Name = "Shape"

	local tabs = create("Frame", {
		Name = "Tabs",
		Size = UDim2.new(1, -6, 1, 0),
		Position = UDim2.fromOffset(3, 0),
		BackgroundTransparency = 1,
	}, navbar)

	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, tabs)

	create("Frame", {
		Name = "TopLeft",
		Size = UDim2.fromOffset(9, 9),
		BackgroundColor3 = theme.Nav,
		BorderSizePixel = 0,
		ZIndex = 2,
	}, navbar)

	create("Frame", {
		Name = "TopRight",
		Size = UDim2.fromOffset(9, 9),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = theme.Nav,
		BorderSizePixel = 0,
		ZIndex = 2,
	}, navbar)

	local content = create("Frame", {
		Name = "Content",
		Size = UDim2.new(1, -SIDE * 2, 1, -(CONTENT_TOP + BOTTOM)),
		Position = UDim2.new(0, SIDE, 0, CONTENT_TOP),
		BackgroundTransparency = 1,
	}, main)

	window.gui = gui
	window.main = main
	window.titlebar = titlebar
	window.title = title
	window.subtitle = subtitle
	window.controls = controls
	window.navbar = navbar
	window.tabbar = tabs
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
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if not hits(input, titlebar) then
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
		window:Minimize()
	end)

	close.MouseButton1Click:Connect(function()
		window:Close()
	end)

	window:SetNavEnabled(window.navEnabled)

	if config.page then
		window:Page(config.page, config.icon or "home")
	end

	return window
end

function Window:Page(name, icon)
	local page = setmetatable({}, Page)
	page.name = name or "Page"
	page.order = 0

	local scroll = create("ScrollingFrame", {
		Name = page.name,
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
		Visible = false,
	}, self.content)

	local holder = create("Frame", {
		Name = "Holder",
		Size = UDim2.new(1, -6, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
	}, scroll)

	create("UIPadding", {
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 12),
	}, holder)

	create("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, holder)

	page.instance = scroll
	page.holder = holder
	page.window = self
	page.teardowns = {}

	table.insert(self.pages, page)
	self:Tab(page, icon)

	if #self.pages == 1 then
		self:Select(page.name)
	end

	return page
end

function Window:Tab(page, icon)
	local existing = self.tabs[page]
	if existing then
		existing.instance:Destroy()
		self.tabs[page] = nil
	end

	local tab = create("TextButton", {
		Name = "Tab",
		Size = UDim2.fromOffset(29, 29),
		BackgroundColor3 = theme.NavActive,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = #self.pages,
	}, self.tabbar)
	round(tab, 5)

	local holder = buildIcon(tab, icon or "list", theme.Icon, 15)

	tab.MouseButton1Click:Connect(function()
		self:Select(page.name)
	end)

	tab.MouseEnter:Connect(function()
		if self.current ~= page then
			tween(tab, { BackgroundTransparency = 0.55 }, 0.15)
		end
	end)

	tab.MouseLeave:Connect(function()
		if self.current ~= page then
			tween(tab, { BackgroundTransparency = 1 }, 0.15)
		end
	end)

	self.tabs[page] = { instance = tab, icon = holder }
	self:ResizeNav()
	return tab
end

function Window:ResizeNav()
	local count = 0
	for _ in pairs(self.tabs) do
		count = count + 1
	end
	if count == 0 then
		return
	end
	tween(self.navbar, { Size = UDim2.fromOffset(count * 29 + 6, NAV_HEIGHT) }, 0.2)
end

function Window:Select(name)
	local target
	for _, page in ipairs(self.pages) do
		if page.name == name then
			target = page
		end
	end
	if not target then
		return self.current
	end

	for _, page in ipairs(self.pages) do
		page.instance.Visible = page == target
	end

	for page, tab in pairs(self.tabs) do
		local active = page == target
		tween(tab.instance, { BackgroundTransparency = active and 0 or 1 }, 0.15)
		tint(tab.icon, active and theme.IconActive or theme.Icon)
	end

	self.current = target
	return target
end

function Window:SetNavEnabled(enabled)
	self.navEnabled = enabled and true or false
	self.navbar.Visible = self.navEnabled

	if self.navEnabled then
		self.content.Position = UDim2.new(0, SIDE, 0, CONTENT_TOP)
		self.content.Size = UDim2.new(1, -SIDE * 2, 1, -(CONTENT_TOP + BOTTOM))
	else
		self.content.Position = UDim2.new(0, SIDE, 0, CONTENT_TOP_PLAIN)
		self.content.Size = UDim2.new(1, -SIDE * 2, 1, -(CONTENT_TOP_PLAIN + BOTTOM))
	end

	return self
end

function Window:SetTitle(text)
	self.title.Text = text
	return self
end

function Window:SetSubtitle(text)
	self.subtitle.Text = text
	return self
end

function Window:Minimize()
	if self.minimized then
		self.minimized = false
		tween(self.main, { Size = self.restore or self.size }, 0.25, Enum.EasingStyle.Quint)
	else
		self.restore = self.main.Size
		self.minimized = true
		tween(self.main, {
			Size = UDim2.new(self.main.Size.X.Scale, self.main.Size.X.Offset, 0, TITLE_HEIGHT),
		}, 0.25, Enum.EasingStyle.Quint)
	end
	return self.minimized
end

function Window:Close()
	if self.closing then
		return
	end
	self.closing = true

	for _, connection in ipairs(self.connections) do
		connection:Disconnect()
	end

	for _, page in ipairs(self.pages) do
		page:Teardown()
	end

	local animation = tween(self.main, {
		Size = UDim2.new(self.main.Size.X.Scale, self.main.Size.X.Offset, 0, 0),
	}, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	animation.Completed:Connect(function()
		self.gui:Destroy()
	end)
end

function Window:Destroy()
	for _, connection in ipairs(self.connections) do
		connection:Disconnect()
	end
	for _, page in ipairs(self.pages) do
		page:Teardown()
	end
	self.gui:Destroy()
end

function Page:Next()
	self.order = self.order + 1
	return self.order
end

function Page:Register(teardown)
	table.insert(self.teardowns, teardown)
	return teardown
end

function Page:Teardown()
	for _, teardown in ipairs(self.teardowns) do
		teardown()
	end
	self.teardowns = {}
end

function Page:Section(text)
	local label = create("TextLabel", {
		Name = "Section",
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		FontFace = theme.FontBold,
		TextSize = 14,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = text or "Section",
		LayoutOrder = self:Next(),
	}, self.holder)

	local wrapper = object(label)
	function wrapper:SetText(value)
		label.Text = value
	end
	return wrapper
end

function Page:Label(text)
	local label = create("TextLabel", {
		Name = "Label",
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		FontFace = theme.FontRegular,
		TextSize = 13,
		TextColor3 = theme.TextSoft,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Text = text or "",
		LayoutOrder = self:Next(),
	}, self.holder)

	local wrapper = object(label)
	function wrapper:SetText(value)
		label.Text = value
	end
	return wrapper
end

function Page:Divider()
	local divider = create("Frame", {
		Name = "Divider",
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = theme.Divider,
		BorderSizePixel = 0,
		LayoutOrder = self:Next(),
	}, self.holder)
	return object(divider)
end

local function rowLabels(parent, config, width, description, fallback, pinned)
	local title = create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -(width + 30), 0, 16),
		Position = (description or pinned) and UDim2.fromOffset(12, 9) or UDim2.new(0, 12, 0.5, -8),
		BackgroundTransparency = 1,
		FontFace = theme.FontRegular,
		TextSize = 14,
		TextColor3 = theme.TextSoft,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.title or fallback or "Option",
	}, parent)

	if description then
		create("TextLabel", {
			Name = "Desc",
			Size = UDim2.new(1, -(width + 30), 0, 14),
			Position = UDim2.fromOffset(12, 27),
			BackgroundTransparency = 1,
			FontFace = theme.FontRegular,
			TextSize = 12,
			TextColor3 = theme.TextDim,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = description,
		}, parent)
	end

	return title
end

local function row(parent, config, width, order, interactive, name, pinned)
	local description = config.desc or config.description
	local properties = {
		Name = name or "Row",
		Size = UDim2.new(1, 0, 0, description and 52 or 35),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		LayoutOrder = order,
	}

	if interactive then
		properties.Text = ""
		properties.AutoButtonColor = false
	end

	local panel = create(interactive and "TextButton" or "Frame", properties, parent)
	round(panel, 6)

	local controlPosition = description and UDim2.new(1, -12, 0, 17) or UDim2.new(1, -12, 0.5, 0)
	return panel, rowLabels(panel, config, width, description, nil, pinned), controlPosition
end

function Page:Button(config)
	local config = config or {}
	local callback = config.callback
	local panel, title, controlPosition = row(self.holder, config, 78, self:Next(), true, "Button")

	local pill = create("Frame", {
		Name = "Pill",
		Size = UDim2.fromOffset(78, 24),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = controlPosition,
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
	}, panel)
	round(pill, 12)

	local pillText = create("TextLabel", {
		Name = "Label",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		FontFace = theme.Font,
		TextSize = 13,
		TextColor3 = theme.TextSoft,
		Text = config.button or "Run",
	}, pill)

	if config.variant == "outlined" then
		stroke(panel, theme.Divider, 1)
		stroke(pill, theme.Stroke, 1)
	end

	panel.MouseEnter:Connect(function()
		tween(panel, { BackgroundColor3 = theme.Hover }, 0.15)
		tween(pill, { BackgroundColor3 = theme.Accent }, 0.15)
		tween(pillText, { TextColor3 = Color3.fromRGB(0, 0, 0) }, 0.15)
	end)

	panel.MouseLeave:Connect(function()
		tween(panel, { BackgroundColor3 = theme.Panel }, 0.15)
		tween(pill, { BackgroundColor3 = theme.Control }, 0.15)
		tween(pillText, { TextColor3 = theme.TextSoft }, 0.15)
	end)

	panel.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	local wrapper = object(panel)
	function wrapper:SetTitle(value)
		title.Text = value
	end
	function wrapper:SetButton(value)
		pillText.Text = value
	end
	function wrapper:SetCallback(value)
		callback = value
	end
	return wrapper
end

function Page:Toggle(config)
	local config = config or {}
	local value = config.value == true
	local callback = config.callback
	local panel, title, controlPosition = row(self.holder, config, 40, self:Next(), true, "Toggle")

	local track = create("Frame", {
		Name = "Switch",
		Size = UDim2.fromOffset(40, 20),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = controlPosition,
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
	}, panel)
	round(track, 10)

	local knob = create("Frame", {
		Name = "Knob",
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.fromOffset(3, 3),
		BackgroundColor3 = theme.TextDim,
		BorderSizePixel = 0,
	}, track)
	round(knob, 7)

	local function render(state, animate)
		local offset = state and 23 or 3
		local trackColor = state and theme.Accent or theme.Control
		local knobColor = state and Color3.fromRGB(0, 0, 0) or theme.TextDim

		if animate then
			tween(track, { BackgroundColor3 = trackColor }, 0.18)
			tween(knob, { BackgroundColor3 = knobColor }, 0.18)
			tween(knob, { Position = UDim2.fromOffset(offset, 3) }, 0.18, Enum.EasingStyle.Quint)
		else
			track.BackgroundColor3 = trackColor
			knob.BackgroundColor3 = knobColor
			knob.Position = UDim2.fromOffset(offset, 3)
		end
	end

	track.MouseButton1Click:Connect(function()
		value = not value
		render(value, true)
		if callback then
			callback(value)
		end
	end)

	render(value, false)

	local wrapper = object(panel)
	function wrapper:SetValue(state)
		value = state == true
		render(value, true)
	end
	function wrapper:GetValue()
		return value
	end
	function wrapper:SetCallback(value2)
		callback = value2
	end
	return wrapper
end

function Page:Slider(config)
	local config = config or {}
	local min = config.min or 0
	local max = config.max or 100
	local decimals = config.decimals or 0
	local callback = config.callback
	local suffix = config.suffix or ""
	local value = min
	local description = config.desc or config.description
	local panel = row(self.holder, config, 90, self:Next(), false, "Slider", true)
	panel.Size = UDim2.new(1, 0, 0, description and 70 or 54)

	local readout = create("TextLabel", {
		Name = "Readout",
		Size = UDim2.new(0, 90, 0, 16),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 9),
		BackgroundTransparency = 1,
		FontFace = theme.Font,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Right,
		Text = "",
	}, panel)

	local trackY = description and 50 or 36

	local track = create("Frame", {
		Name = "Track",
		Size = UDim2.new(1, -40, 0, 4),
		Position = UDim2.fromOffset(20, trackY),
		BackgroundColor3 = theme.Track,
		BorderSizePixel = 0,
	}, panel)
	round(track, 2)

	local fill = create("Frame", {
		Name = "Fill",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
	}, track)
	round(fill, 2)

	local knob = create("Frame", {
		Name = "Knob",
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
	}, track)
	round(knob, 8)

	local hit = create("TextButton", {
		Name = "Hit",
		Size = UDim2.new(1, -24, 0, 26),
		Position = UDim2.fromOffset(12, trackY - 11),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, panel)
	knob.ZIndex = 2
	hit.ZIndex = 3

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
	function wrapper:SetCallback(value2)
		callback = value2
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

function Page:TextBox(config)
	local config = config or {}
	local callback = config.callback
	local panel, title, controlPosition = row(self.holder, config, 170, self:Next(), false, "TextBox")

	local input = create("TextBox", {
		Name = "Input",
		Size = UDim2.fromOffset(158, 25),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = controlPosition,
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
	round(input, 5)

	create("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
	}, input)

	local outline = stroke(panel, theme.Divider, 1)

	input.Focused:Connect(function()
		tween(outline, { Color = theme.Stroke }, 0.15)
	end)

	input.FocusLost:Connect(function(enterPressed)
		tween(outline, { Color = theme.Divider }, 0.15)
		if callback then
			callback(input.Text, enterPressed)
		end
	end)

	local wrapper = object(panel)
	function wrapper:SetText(text)
		input.Text = text
	end
	function wrapper:GetText()
		return input.Text
	end
	function wrapper:SetPlaceholder(text)
		input.PlaceholderText = text
	end
	function wrapper:SetCallback(value)
		callback = value
	end
	return wrapper
end

function Page:Keybind(config)
	local config = config or {}
	local callback = config.callback
	local key = config.key
	local listening = false
	local connections = {}

	if key == Enum.KeyCode.Unknown then
		key = nil
	end

	local panel, title, controlPosition = row(self.holder, config, 110, self:Next(), true, "Keybind")

	local button = create("TextButton", {
		Name = "Bind",
		Size = UDim2.fromOffset(110, 23),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = controlPosition,
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		FontFace = theme.Font,
		TextSize = 13,
		TextColor3 = theme.TextSoft,
		Text = key and key.Name or "None",
	}, panel)
	round(button, 5)

	local function isMouse(input)
		return input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.MouseButton2
			or input.UserInputType == Enum.UserInputType.MouseButton3
	end

	local function refresh()
		button.Text = key and key.Name or "None"
	end

	table.insert(connections, UserInputService.InputBegan:Connect(function(input)
		if not listening then
			return
		end
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
		if callback then
			callback(key)
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
	function wrapper:SetCallback(value)
		callback = value
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

function Page:Dropdown(config)
	local config = config or {}
	local options = config.options or {}
	local callback = config.callback
	local selected = config.default
	local expanded = false
	local panel, title, controlPosition = row(self.holder, config, 170, self:Next(), true, "Dropdown")

	local shell = create("TextButton", {
		Name = "Shell",
		Size = UDim2.fromOffset(170, 27),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = controlPosition,
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, panel)
	round(shell, 5)

	local label = rowLabels(shell, {}, 34, nil, "Select...")
	label.Text = selected ~= nil and tostring(selected) or (config.placeholder or "Select...")
	label.TextColor3 = selected ~= nil and theme.TextSoft or theme.TextDim

	local chevron = create("Frame", {
		Name = "Chevron",
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		BackgroundTransparency = 1,
	}, shell)
	Icons.chevron(chevron, theme.TextDim)

	local list = create("Frame", {
		Name = "List",
		Size = UDim2.new(0, 170, 0, 0),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 1, 2),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 5,
	}, panel)
	round(list, 6)

	local scroll = create("ScrollingFrame", {
		Size = UDim2.new(1, -8, 1, -8),
		Position = UDim2.fromOffset(4, 4),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70),
		ScrollBarImageTransparency = 0.2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
	}, list)

	local optionsHolder = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
	}, scroll)

	create("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, optionsHolder)

	local entries = {}

	local function shownHeight()
		local visible = math.min(#options, 4)
		return visible * 28 + math.max(visible - 1, 0) * 4 + 8
	end

	local function refresh()
		for _, entry in ipairs(entries) do
			entry:Destroy()
		end
		entries = {}

		for index, option in ipairs(options) do
			local entry = create("TextButton", {
				Name = "Option",
				Size = UDim2.new(1, 0, 0, 28),
				BackgroundColor3 = theme.Control,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				FontFace = theme.FontRegular,
				TextSize = 13,
				TextColor3 = option == selected and theme.Text or theme.TextSoft,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = tostring(option),
				LayoutOrder = index,
			}, optionsHolder)
			round(entry, 4)
			create("UIPadding", { PaddingLeft = UDim.new(0, 10) }, entry)

			entry.MouseEnter:Connect(function()
				tween(entry, { BackgroundColor3 = theme.Hover }, 0.12)
			end)

			entry.MouseLeave:Connect(function()
				tween(entry, { BackgroundColor3 = theme.Control }, 0.12)
			end)

			entry.MouseButton1Click:Connect(function()
				selected = option
				label.Text = tostring(option)
				label.TextColor3 = theme.TextSoft
				expanded = false
				tween(list, { Size = UDim2.new(0, 170, 0, 0) }, 0.18)
				tween(chevron, { Rotation = 0 }, 0.18)
				if callback then
					callback(option)
				end
			end)

			table.insert(entries, entry)
		end
	end

	shell.MouseButton1Click:Connect(function()
		if expanded then
			expanded = false
			tween(list, { Size = UDim2.new(0, 170, 0, 0) }, 0.18)
			tween(chevron, { Rotation = 0 }, 0.18)
		else
			expanded = true
			tween(list, { Size = UDim2.new(0, 170, 0, shownHeight()) }, 0.18)
			tween(chevron, { Rotation = 180 }, 0.18)
		end
	end)

	refresh()

	local wrapper = object(panel)
	function wrapper:SetOptions(values)
		options = values or {}
		refresh()
		if expanded then
			list.Size = UDim2.new(0, 170, 0, shownHeight())
		end
	end
	function wrapper:SetValue(value)
		selected = value
		label.Text = value ~= nil and tostring(value) or "Select..."
		label.TextColor3 = value ~= nil and theme.TextSoft or theme.TextDim
		refresh()
	end
	function wrapper:GetValue()
		return selected
	end
	function wrapper:SetCallback(value)
		callback = value
	end
	return wrapper
end

function Page:Destroy()
	self:Teardown()
	self.instance:Destroy()
	return self
end

return UILib
