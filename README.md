# saint-ui

A single-file UI library for Roblox script executors. Dark theme, nav tabs, draggable window.

Built from a hand-made design mockup, so it keeps that look: `#0A0A0A` window, `#1F1F1F` nav and
dividers, off-white buttons, 6px corners, 58px titlebar.

## Load

```lua
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/saintdevzz/saint-ui/main/UILIB.lua"))()
local Demo = loadstring(game:HttpGet("https://raw.githubusercontent.com/saintdevzz/saint-ui/main/Demo.lua"))()
```

`Demo.lua` builds a two-page example with every component. Run it to see what the library can do.

## Quick start

```lua
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/saintdevzz/saint-ui/main/UILIB.lua"))()

local window = UILib:Window({
    title = "Saint",
    subtitle = "v0.0.1",
    size = UDim2.fromOffset(639, 441),
    position = 0.5,
})

local main = window:Page("Main", "home")

main:Section("Combat")

main:Button({
    title = "Execute",
    callback = function()
        print("pressed")
    end,
})

main:Slider({
    title = "WalkSpeed",
    min = 16,
    max = 200,
    value = 16,
    callback = function(value)
        print(value)
    end,
})
```

## Window

```lua
UILib:Window({
    title = "Saint",
    subtitle = "v0.0.1",
    size = UDim2.fromOffset(639, 441),
    position = 0.5,
    nav = true,
    name = "UILib",
    displayOrder = 100,
    parent = nil,
    page = nil,
    icon = nil,
})
```

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `title` | string | `"Saint"` | Titlebar text |
| `subtitle` | string | `"v0.0.1"` | Dim line under the title |
| `size` | UDim2 | `639x441` | Restored size, also used by minimize |
| `position` | number | `0.5` | Screen scale on both axes |
| `nav` | boolean | `true` | Set `false` for a single-page script |
| `name` | string | `"UILib"` | ScreenGui name |
| `displayOrder` | number | `100` | ScreenGui display order |
| `parent` | Instance | PlayerGui | Where the ScreenGui goes |
| `page` / `icon` | string | `nil` | Creates the first page for you |

Methods:

| Call | Does |
| --- | --- |
| `window:Page(name, icon)` | Adds a page and its nav tab, returns the page |
| `window:Tab(page, icon)` | Recreates a page's tab button |
| `window:Select(name)` | Switches page |
| `window:SetNavEnabled(bool)` | Shows or hides the nav and reflows the content area |
| `window:SetTitle(text)` | Updates the title |
| `window:SetSubtitle(text)` | Updates the subtitle |
| `window:Minimize()` | Toggles collapsed state, returns the new state |
| `window:Close()` | Animates out and destroys the GUI |
| `window:Destroy()` | Destroys immediately |

Window controls work out of the box: drag by the titlebar, `-` collapses to the titlebar height,
`X` closes. Collapsing works because the main frame clips its descendants.

## Pages

```lua
local page = window:Page("Settings", "settings")

page:Section("Heading")
page:Label("Some text")
page:Divider()
```

Available icons for `Page`: `home`, `settings`, `user`, `code`, `list`, `star`, `shield`,
`folder`, `search`, `power`, `chevron`. An unknown name just renders an empty slot. You can also pass
an asset id like `"rbxassetid://1234"` or an `https://` image URL and it will be used as an
`ImageLabel` instead of a drawn icon.

## Components

Everything returns a wrapper with `instance` (the real Instance), `Destroy`, and the setters listed
below.

### Button

```lua
local button = page:Button({
    title = "Execute",
    variant = "filled",
    callback = function() end,
})
button:SetTitle("Running")
button:SetCallback(function() print("new callback") end)
```

`variant` is `"filled"` (default, off-white) or `"outlined"` (dark with a stroke). Both tween on
hover.

### Toggle

```lua
local toggle = page:Toggle({ title = "Infinite Jump", value = false, callback = function(v) end })
toggle:SetValue(true)
toggle:GetValue()
```

`SetValue` renders without firing the callback.

### Slider

```lua
local slider = page:Slider({
    title = "WalkSpeed",
    min = 16,
    max = 200,
    value = 16,
    decimals = 0,
    suffix = "",
    callback = function(value) end,
})
slider:SetValue(100)
slider:GetValue()
```

Click anywhere on the track to jump, or hold and drag. Dragging is tracked on
`UserInputService.InputChanged`, so the knob keeps following the cursor outside the window. Values
are clamped and rounded to `decimals` places.

### TextBox

```lua
local box = page:TextBox({
    placeholder = "Type here...",
    text = "",
    callback = function(text, enterPressed) end,
})
box:SetText("hello")
box:GetText()
box:SetPlaceholder("hint")
```

The callback receives the text and whether the user pressed Enter.

### Keybind

```lua
local bind = page:Keybind({
    title = "Toggle Menu",
    key = Enum.KeyCode.RightShift,
    callback = function(key) end,
})
bind:SetKey(Enum.KeyCode.F1)
bind:GetKey()
```

Clicking the button shows `Press a key...` and waits for the next keyboard key or mouse button. For
mouse input the callback receives the `Enum.UserInputType`; for keys it receives the `Enum.KeyCode`.
Either type can be passed as the default `key`.

### Dropdown

```lua
local dropdown = page:Dropdown({
    options = { "Legit", "Rage", "Silent Aim" },
    default = "Legit",
    placeholder = "Select...",
    callback = function(option) end,
})
dropdown:SetValue("Rage")
dropdown:GetValue()
dropdown:SetOptions({ "One", "Two" })
```

The list expands with a tween and scrolls once it passes four visible rows, so long option lists
stay inside the window.

## Theming

`UILib.Theme` is a single table read at build time, so change it before creating the window:

```lua
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/saintdevzz/saint-ui/main/UILIB.lua"))()

UILib.Theme.Window = Color3.fromRGB(12, 12, 14)
UILib.Theme.Nav = Color3.fromRGB(24, 24, 28)
UILib.Theme.Accent = Color3.fromRGB(120, 170, 255)

local window = UILib:Window({ title = "Saint", subtitle = "v0.0.1" })
```

Keys: `Window`, `Panel`, `Control`, `Hover`, `Divider`, `Track`, `Accent`, `Text`, `TextSoft`,
`TextDim`, `Stroke`, `Nav`, `NavActive`, `Icon`, `IconActive`, `Font`, `FontRegular`, `FontBold`.

Titles, version strings, and font family are all just options, so nothing about the design is
hardcoded to the original mockup.

## Notes

- `Design.lua` is the original hand-built Studio mockup this library was rewritten from. It is kept
  as the visual reference, not as working code.
- No external assets. Icons are drawn from frames and strokes, and the font family is the built-in
  Gotham SSm, so nothing depends on an asset id that might be private.
- Page content lives in a `ScrollingFrame` with `AutomaticCanvasSize`, so components stack by
  layout order instead of fixed coordinates and long pages scroll.
- Closing the window disconnects the input connections the window, slider, and keybind components
  registered, so nothing keeps running after the GUI is gone.
