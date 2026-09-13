# saint-ui

A single-file UI library for Roblox script executors. Dark theme, nav tabs, draggable window.

Built from a hand-made design mockup, so it keeps that look: `#0A0A0A` window, `#1F1F1F` nav and
dividers, off-white buttons, 8px corners, 58px titlebar. The nav sits flush against the separator
and the window's top corners are square, so the nav reads as connected to the titlebar.

Every component is a full-width row: the **name on the left**, the **control on the right**, and an
**optional description under the name**.

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
    logo = "S",
    size = UDim2.fromOffset(639, 441),
    position = 0.5,
})

local main = window:Page("Main", "home")

main:Section("Combat")

main:Button({
    title = "Execute",
    button = "Run",
    desc = "Runs the selected script on your character",
    callback = function()
        print("pressed")
    end,
})

main:Slider({
    title = "WalkSpeed",
    desc = "Drag the knob or click the bar",
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
    logo = nil,
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
| `logo` | number / string | `nil` | 26x26 mark left of the title, see [Icons](#icons) |
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

## Icons

Anything that takes an `icon` or a `logo` accepts the same three kinds of value, tried in order:

1. **A Roblox asset id.** A number (`12345`) or a numeric string (`"12345"`) is normalised to
   `rbxassetid://12345`. A full `rbxassetid://`, `rbxasset://`, or `http(s)://` string is used as
   is. Renders as an `ImageLabel` and is tinted with the row's colour.
2. **A built-in drawn icon.** `home`, `settings`, `user`, `code`, `list`, `star`, `shield`,
   `folder`, `search`, `power`, `chevron`.
3. **Any other text.** Rendered as a bold text glyph, so `"S"` gives you a letter mark and `"AB"`
   gives you two letters.

Passing `nil` on a page falls back to the `list` preset; passing an empty string draws nothing.

```lua
window:Page("Home", "home")                      -- drawn preset
window:Page("Shop", "rbxassetid://123456789")    -- image
window:Page("Tools", 123456789)                  -- image, numeric
window:Page("Me", "S")                           -- text glyph
```

## Pages

```lua
local page = window:Page("Settings", "settings")

page:Section("Heading")
page:Label("Some text")
page:Divider()
```

## Components

Every component is a panel with the title on the left and the control on the right. All of them
accept `title` for the row name, `desc` (alias `description`) for the optional line under it, and
return a wrapper with `instance` (the real Instance), `Destroy`, and the setters listed below.

Rows are 35px tall, or 52px when a `desc` is present. Sliders reserve a little more.

### Button

```lua
local button = page:Button({
    title = "Execute",
    button = "Run",
    desc = "Runs the selected script",
    variant = "filled",
    callback = function() end,
})
button:SetTitle("Running")
button:SetButton("Stop")
button:SetCallback(function() print("new callback") end)
```

`title` is the row name, `button` is the label inside the pill on the right (default `"Run"`).
`variant` is `"filled"` (default, off-white) or `"outlined"` (dark with a stroke). The whole row is
clickable and tints on hover.

### Toggle

```lua
local toggle = page:Toggle({
    title = "Infinite Jump",
    desc = "No fall damage",
    value = false,
    callback = function(v) end,
})
toggle:SetValue(true)
toggle:GetValue()
```

`SetValue` renders without firing the callback. The switch on the right is the click target.

### Slider

```lua
local slider = page:Slider({
    title = "WalkSpeed",
    desc = "Drag the knob or click the bar",
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
are clamped and rounded to `decimals` places, and the readout sits at the top right of the row.

### TextBox

```lua
local box = page:TextBox({
    title = "Display Name",
    desc = "Press enter to fire the callback",
    placeholder = "Type here...",
    text = "",
    callback = function(text, enterPressed) end,
})
box:SetText("hello")
box:GetText()
box:SetPlaceholder("hint")
```

The input is a pill on the right of the row. The callback receives the text and whether the user
pressed Enter.

### Keybind

```lua
local bind = page:Keybind({
    title = "Toggle Menu",
    desc = "Click the pill then press any key",
    key = Enum.KeyCode.RightShift,
    callback = function(key) end,
})
bind:SetKey(Enum.KeyCode.F1)
bind:GetKey()
```

Clicking the pill shows `Press a key...` and waits for the next keyboard key or mouse button. For
mouse input the callback receives the `Enum.UserInputType`; for keys it receives the `Enum.KeyCode`.
Either type can be passed as the default `key`; `Enum.KeyCode.Unknown` means unbound.

### Dropdown

```lua
local dropdown = page:Dropdown({
    title = "Mode",
    desc = "Picks a single option",
    options = { "Legit", "Rage", "Silent Aim" },
    default = "Legit",
    placeholder = "Select...",
    callback = function(option) end,
})
dropdown:SetValue("Rage")
dropdown:GetValue()
dropdown:SetOptions({ "One", "Two" })
```

The shell on the right shows the current value or the placeholder. The list opens under the row,
right aligned, and scrolls once it passes four visible rows, so long option lists stay inside the
window.

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

Titles, version strings, the logo, and the font family are all just options, so nothing about the
design is hardcoded to the original mockup.

## Notes

- `Design.lua` is the original hand-built Studio mockup this library was rewritten from. It is kept
  as the visual reference, not as working code.
- No external assets. Icons are drawn from frames and strokes if you do not pass an asset id, and
  the font family is the built-in Gotham SSm, so nothing depends on an asset id that might be
  private.
- Page content lives in a `ScrollingFrame` with `AutomaticCanvasSize`, so components stack by
  layout order instead of fixed coordinates and long pages scroll.
- Closing the window disconnects the input connections the window, slider, and keybind components
  registered, so nothing keeps running after the GUI is gone.
