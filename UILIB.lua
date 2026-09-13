local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local TITLE_HEIGHT = 58
local NAV_TOP = 62
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

local function buildIcon(parent, name, color)
	local holder = create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	}, parent)

	if type(name) == "string" and (name:match("^rbxasset") or name:match("^https?://")) then
		create("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = name,
			ImageColor3 = color,
			ScaleType = Enum.ScaleType.Fit,
		}, holder)
	elseif name and Icons[name] then
		Icons[name](holder, color)
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
	round(main, 6)

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
	}, titlebar)

	local title = create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -140, 0, 18),
		Position = UDim2.fromOffset(14, 12),
		BackgroundTransparency = 1,
		FontFace = theme.Font,
		TextSize = 16,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.title or "Saint",
	}, titlebar)

	local subtitle = create("TextLabel", {
		Name = "Subtitle",
		Size = UDim2.new(1, -140, 0, 14),
		Position = UDim2.fromOffset(14, 31),
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

	local stem = create("Frame", {
		Name = "Stem",
		Size = UDim2.fromOffset(1, NAV_TOP - TITLE_HEIGHT),
		Position = UDim2.new(0.5, 0, 0, TITLE_HEIGHT),
		BackgroundColor3 = theme.Divider,
		BorderSizePixel = 0,
	}, main)

	local navbar = create("Frame", {
		Name = "Nav",
		Size = UDim2.new(0, 0, 0, NAV_HEIGHT),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, NAV_TOP),
		BackgroundColor3 = theme.Nav,
		BorderSizePixel = 0,
	}, main)
	round(navbar, 6)

	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 0),
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
	window.stem = stem
	window.navbar = navbar
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
	}, self.navbar)
	round(tab, 5)

	local holder = buildIcon(tab, icon or "list", theme.Icon)

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
	self.stem.Visible = self.navEnabled

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

function Page:Button(config)
	local config = config or {}
	local outlined = config.variant == "outlined"
	local callback = config.callback
	local base = outlined and theme.Window or theme.Accent

	local button = create("TextButton", {
		Name = "Button",
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = base,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		FontFace = theme.Font,
		TextSize = 15,
		TextColor3 = outlined and theme.Text or Color3.fromRGB(0, 0, 0),
		Text = config.title or "Button",
		LayoutOrder = self:Next(),
	}, self.holder)
	round(button, 32)

	if outlined then
		stroke(button, theme.Stroke, 1)
	end

	button.MouseEnter:Connect(function()
		tween(button, { BackgroundColor3 = outlined and theme.Hover or Color3.fromRGB(255, 255, 255) }, 0.15)
	end)

	button.MouseLeave:Connect(function()
		tween(button, { BackgroundColor3 = base }, 0.15)
	end)

	button.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	local wrapper = object(button)
	function wrapper:SetTitle(value)
		button.Text = value
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

	local panel = create("Frame", {
		Name = "Toggle",
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		LayoutOrder = self:Next(),
	}, self.holder)
	round(panel, 6)

	create("TextLabel", {
		Size = UDim2.new(1, -70, 1, 0),
		Position = UDim2.fromOffset(12, 0),
		BackgroundTransparency = 1,
		FontFace = theme.FontRegular,
		TextSize = 14,
		TextColor3 = theme.TextSoft,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.title or "Toggle",
	}, panel)

	local track = create("TextButton", {
		Name = "Switch",
		Size = UDim2.fromOffset(40, 20),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
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

	local panel = create("Frame", {
		Name = "Slider",
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		LayoutOrder = self:Next(),
	}, self.holder)
	round(panel, 6)

	create("TextLabel", {
		Size = UDim2.new(1, -110, 0, 16),
		Position = UDim2.fromOffset(12, 9),
		BackgroundTransparency = 1,
		FontFace = theme.FontRegular,
		TextSize = 14,
		TextColor3 = theme.TextSoft,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.title or "Slider",
	}, panel)

	local readout = create("TextLabel", {
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

	local track = create("Frame", {
		Name = "Track",
		Size = UDim2.new(1, -40, 0, 4),
		Position = UDim2.fromOffset(20, 32),
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
		Position = UDim2.fromOffset(12, 21),
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

	local shell = create("Frame", {
		Name = "TextBox",
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		LayoutOrder = self:Next(),
	}, self.holder)
	round(shell, 6)
	local outline = stroke(shell, theme.Divider, 1)

	local input = create("TextBox", {
		Name = "Input",
		Size = UDim2.new(1, -24, 1, 0),
		Position = UDim2.fromOffset(12, 0),
		BackgroundTransparency = 1,
		FontFace = theme.FontRegular,
		TextSize = 14,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		PlaceholderText = config.placeholder or "Type here...",
		PlaceholderColor3 = theme.TextDim,
		ClearTextOnFocus = false,
		Text = config.text or "",
	}, shell)

	input.Focused:Connect(function()
		tween(outline, { Color = theme.Stroke }, 0.15)
	end)

	input.FocusLost:Connect(function(enterPressed)
		tween(outline, { Color = theme.Divider }, 0.15)
		if callback then
			callback(input.Text, enterPressed)
		end
	end)

	local wrapper = object(shell)
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

	local panel = create("Frame", {
		Name = "Keybind",
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		LayoutOrder = self:Next(),
	}, self.holder)
	round(panel, 6)

	create("TextLabel", {
		Size = UDim2.new(1, -130, 1, 0),
		Position = UDim2.fromOffset(12, 0),
		BackgroundTransparency = 1,
		FontFace = theme.FontRegular,
		TextSize = 14,
		TextColor3 = theme.TextSoft,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.title or "Keybind",
	}, panel)

	local button = create("TextButton", {
		Name = "Bind",
		Size = UDim2.new(0, 110, 0, 23),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
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

	local container = create("Frame", {
		Name = "Dropdown",
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = self:Next(),
	}, self.holder)

	local shell = create("TextButton", {
		Name = "Shell",
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, container)
	round(shell, 6)

	local label = create("TextLabel", {
		Size = UDim2.new(1, -70, 1, 0),
		Position = UDim2.fromOffset(12, 0),
		BackgroundTransparency = 1,
		FontFace = theme.FontRegular,
		TextSize = 14,
		TextColor3 = selected ~= nil and theme.TextSoft or theme.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = selected ~= nil and tostring(selected) or (config.placeholder or "Select..."),
	}, shell)

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
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.fromOffset(0, 35),
		BackgroundColor3 = theme.Control,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, container)
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

	local function contentHeight()
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
				tween(list, { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
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
			tween(list, { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
			tween(chevron, { Rotation = 0 }, 0.18)
		else
			expanded = true
			tween(list, { Size = UDim2.new(1, 0, 0, contentHeight()) }, 0.18)
			tween(chevron, { Rotation = 180 }, 0.18)
		end
	end)

	refresh()

	local wrapper = object(container)
	function wrapper:SetOptions(values)
		options = values or {}
		refresh()
		if expanded then
			list.Size = UDim2.new(1, 0, 0, contentHeight())
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
