# saint-ui

A single-file UI library for Roblox script executors. Two-pane dark menu, side nav, expandable
sub-menus, and an overlay window you open and close with **RightShift**.

The look is a clicky client menu, not a settings app. **Everything is text.** No icons, no logo, no
glyph fonts. If you pass a real `rbxassetid://` (or a bare numeric id, or an `http(s)` image url) the
library draws it; otherwise it draws nothing at all. No placeholders, no letter marks, no empty boxes.

```
+-----------------------------------------------------------+
|  Saint                                              -  X |  header 56px
+----------------+-------------------------------------------+
|   Home         |  QUICK ACTIONS                            |
|   Combat       |  Everything on this page is live          |
|   Settings     |  [ Execute                    ( Run )  ] |
|                |  [ Movement                  ( v )    ] |
|   sidebar      |  [   Sprint                 (====)    ] |
|   176px        |  [   WalkSpeed      80        (---o-)  ] |
+----------------+-------------------------------------------+
```

## Load

```lua
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/saintdevzz/saint-ui/main/UILIB.lua"))()
local Demo = loadstring(game:HttpGet("https://raw.githubusercontent.com/saintdevzz/saint-ui/main/Demo.lua"))()
```

`Demo.lua` builds a three-page example (`Home`, `Combat`, `Settings`) with every component, including
two expandable sub-menus. Run it to see what the library can do.

Pin the loadstring to a commit if you need the library to stop moving:

```lua
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/saintdevzz/saint-ui/<sha>/UILIB.lua"))()
```

## Quick start

```lua
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/saintdevzz/saint-ui/main/UILIB.lua"))()

local window = UILib:Window({
    title = "Saint",
    subtitle = "v0.0.1",
    size = UDim2.fromOffset(720, 470),
})

local combat = window:Page("Combat")

combat:Group("Aim")

combat:Toggle({
    title = "AimAssist",
    desc = "Pulls your crosshair toward the nearest target",
    value = true,
    callback = function(state)
        print(state)
    end,
})

combat:Slider({
    title = "FOV",
    min = 0,
    max = 360,
    value = 90,
    suffix = " deg",
    callback = function(value)
        print(value)
    end,
})

local silent = combat:Module({
    title = "Silent aim",
    desc = "Routes hits through a separate raycast",
})

silent:Keybind({
    title = "Trigger",
    key = Enum.KeyCode.Q,
    mode = "hold",
    callback = function(active)
        print(active)
    end,
})

window:Select("Combat")
```

## The overlay toggle

The whole window is one overlay. **RightShift** opens and closes it, and while it is closed nothing is
rendered or listening. Pass `toggleKey = false` to opt out and drive visibility yourself.

```lua
local a = UILib:Window({ toggleKey = Enum.KeyCode.RightControl })  -- different key
local b = UILib:Window({ toggleKey = false })                      -- you control it
```

| Call | Does |
| --- | --- |
| `window:SetOpen(bool)` | Animates the window in or out, enables and disables the `ScreenGui` |
| `window:Toggle()` | Flips it, returns the new state |
| `window:IsOpen()` | Current state |
| `window:SetToggleKey(key)` | Rebinds or disables (`false`) the hotkey |
| `window:SetToggleLocked(bool)` | Ignores the hotkey while other controls are listening |

Opening tweens the height from zero to full over `0.28s` with a quint ease, so the menu unfolds.
Closing shrinks it back and only hides the `ScreenGui` once the tween finishes. `SetOpen` never
destroys anything, so state, values and connections all survive a close.

The header `-` button also calls `SetOpen(false)`. `SetSize(size)` updates the restored size the
animation lands on.

## Window

```lua
UILib:Window({
    title = "Saint",
    subtitle = "v0.0.1",
    logo = nil,
    size = UDim2.fromOffset(720, 470),
    position = 0.5,
    toggleKey = Enum.KeyCode.RightShift,
    name = "UILib",
    displayOrder = 100,
    parent = nil,
    page = nil,
    icon = nil,
})
```

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| `title` | string | `"Saint"` | Header text |
| `subtitle` | string | `"v0.0.1"` | Dim line under the title, `version` is an alias |
| `logo` | number / string | `nil` | 26x26 image left of the title, see [Icons](#icons) |
| `size` | UDim2 | `700x460` | Full size, also the size the open animation lands on |
| `position` | number | `0.5` | Screen scale on both axes |
| `toggleKey` | EnumItem / `false` | `RightShift` | Hotkey that opens and closes the window |
| `name` | string | `"UILib"` | `ScreenGui` name |
| `displayOrder` | number | `100` | `ScreenGui` display order |
| `parent` | Instance | PlayerGui | Where the `ScreenGui` goes |
| `page` / `icon` | string | `nil` | Creates the first page for you |

| Call | Does |
| --- | --- |
| `window:Page(name, icon)` | Adds a nav entry and its content pane, returns the page |
| `window:Select(name)` | Switches page and closes any open dropdown |
| `window:PageNames()` | Ordered array of page names |
| `window:SetTitle(text)` / `window:SetSubtitle(text)` | Updates the header |
| `window:SetSize(size)` | Updates the restored size |
| `window:CloseFloating()` | Closes open dropdown lists |
| `window:Minimize()` | Same as `SetOpen(false)` |
| `window:Close()` | Animates out and destroys the GUI |
| `window:Destroy()` | Destroys immediately |

Drag the window by the header. The `Controls` cluster in the top right holds two text buttons,
`-` (hide) and `X` (destroy).
## Pages and sub-menus

A **page** is a nav entry in the 176px sidebar with its own scrollable content pane. A **module** is an
expandable row inside a page: a header with a caret that opens a nested list of rows underneath it.
Modules are how clients group related options without spending a whole page on them.

```lua
local page = window:Page("Combat")

local silent = page:Module({
    title = "Silent aim",
    desc = "Optional second line",
    open = false,      -- set true to start expanded
})
```

| Call | Does |
| --- | --- |
| `module:SetOpen(bool)` | Expands or collapses, returns the new state |
| `module:Open()` / `module:Close()` / `module:IsOpen()` | Obvious |
| `module:Destroy()` | Removes the header and every child row |

A collapsed module contributes **zero** height: the children frame flips between
`AutomaticSize = None` and `Y`, so the page reflows as you expand it. Expanded rows are indented 14px
so the nesting reads visually.

`page:Open()` selects the page. Pages and modules share the same control API, so every component below
can go inline on a page or inside a module.

## Components

Every component accepts `title` for the row name and `desc` (alias `description`) for an optional line
under it. A row is **44px** tall, or **62px** with a description. Each returns a wrapper with
`instance` (the real `Instance`), `Destroy`, and the setters listed below.

### `Group(text)`

An uppercase `Theme.TextDim` section heading in a 30px row. Takes a plain string or
`{ text = "..." }`. `SetText(value)` re-uppercases it.

### `Label(text)`

Wrapped body text in `Theme.TextSoft`, 24px tall, `SetText(value)`.

### `Divider()`

A 1px `Theme.Divider` rule inside a 17px transparent row, so the line never sits flush against the rows
above and below.

### `Button`

```lua
local button = page:Button({
    title = "Execute",
    button = "Run",       -- text inside the pill
    desc = "Runs the selected script",
    callback = function() end,
})
button:SetTitle("Running")
button:SetButton("Stop")
button:GetButton()
button:SetCallback(function() print("new callback") end)
```

The pill is `96x30` with a `10px` corner. Hovering the row brightens the panel to `Theme.Hover`, widens
the pill to `104x34`, and flips it to `Theme.Accent` with black text — all tweened, so the whole row
reads as the click target. There is one style; no outlined or transparent variant.

### `Toggle`

```lua
local toggle = page:Toggle({
    title = "Infinite Jump",
    desc = "No fall damage",
    value = false,
    callback = function(state) end,
})
toggle:SetValue(true)
toggle:GetValue()
```

A `46x24` switch with a `12px` corner and a `16px` `8px`-corner knob that slides `4 -> 26`. The track
goes `Theme.Control -> Theme.Accent`, the knob goes `Theme.TextDim -> black`. `SetValue` renders
without firing the callback.

### `Slider`

```lua
local slider = page:Slider({
    title = "WalkSpeed",
    min = 16,
    max = 500,
    value = 80,
    decimals = 0,     -- rounded decimal places
    suffix = " deg",  -- appended to the readout
    callback = function(value) end,
})
slider:SetValue(100)
slider:GetValue()
```

A `6px` `3px`-corner track with an `18px` round `9px`-corner knob, plus a readout in the top right.
The row is `70px` (`88px` with a description). Click anywhere on the track to jump, or hold and drag —
dragging is tracked through `UserInputService`, so the knob keeps following the cursor outside the
window. Values are clamped and rounded to `decimals`.

### `TextBox`

```lua
local box = page:TextBox({
    title = "Profile",
    placeholder = "profile name",
    text = "default",
    callback = function(text, enterPressed) end,
})
box:SetText("hello")
box:GetText()
box:SetPlaceholder("hint")
```

A `196x28` input with an `8px` corner on the right of the row. This is the only control with a
`UIStroke`: it is `Theme.Control` and brightens to `Theme.Stroke` while focused.

### `Keybind`

```lua
local bind = page:Keybind({
    title = "Trigger",
    key = Enum.KeyCode.Q,
    mode = "hold",      -- "hold" or "toggle" (default)
    callback = function(active) end,
})
bind:SetKey(Enum.KeyCode.F1)
bind:GetKey()
```

A `120x28` pill showing the bound key or `None`. Clicking it shows `Press a key...` and waits for the
next keyboard key or mouse button.

- `mode = "toggle"` (default) — each press flips a boolean and the callback fires with it.
- `mode = "hold"` — the callback fires `true` on key-down and `false` on key-up.

Both fire globally through `UserInputService`, so the control does not need GUI focus. While a pill is
listening, the window hotkey is locked out automatically so a rebind cannot collapse the menu
mid-click; `SetToggleLocked` is the manual version.

### `Dropdown`

```lua
local dropdown = page:Dropdown({
    title = "Mode",
    options = { "Legit", "Rage", "Silent Aim" },
    default = "Legit",
    placeholder = "Select...",
    width = 196,
    callback = function(option) end,
})
dropdown:SetValue("Rage")
dropdown:GetValue()
dropdown:SetOptions({ "One", "Two" })
```

A `196x30` `8px`-corner shell with a caret that rotates `180` degrees when opened. The option list is
**floating**: it is parented to an overlay outside the window's clipped frame, so it draws above
everything, is never cut off by a window edge, and is free to overflow the row. Options are `32px`
tall, up to five show before it scrolls, and the list is placed below or above the shell depending on
where there is room.

Only one list is open at a time per page; switching pages, selecting an option, or `CloseFloating()`
closes it. The selected option is `Theme.Text`, the rest `Theme.TextSoft`.

## Icons

Icons and logos are **images only**, from a real asset id. A `number` (`12345`) or a numeric string
(`"12345"`) is normalised to `rbxassetid://12345`; a full `rbxassetid://`, `rbxasset://`, or
`http(s)://` string is used as is. Anything else is treated as "no icon".

```lua
window:Page("Home", "rbxassetid://123456789")    -- image
window:Page("Tools", 123456789)                  -- image, numeric
window:Page("Raw", "https://example.com/i.png")  -- image, direct url
window:Page("Plain")                             -- no icon at all
window:Page("AlsoPlain", "star")                 -- still nothing: "star" is not an asset id
```

Nav entries are pure text by default and never reserve space for an icon. When you do pass one, the
entry indents its label 24px and the image is tinted `Theme.Icon`, switching to `Theme.IconActive`
while selected. Same rule for `logo` in the header.

## Theming

`UILib.Theme` is read as each instance is built, so change it before creating the window:

```lua
UILib.Theme.Window = Color3.fromRGB(12, 12, 14)
UILib.Theme.Accent = Color3.fromRGB(120, 170, 255)
UILib.Theme.NavActive = Color3.fromRGB(30, 40, 55)

local window = UILib:Window({ title = "Saint", subtitle = "v0.0.1" })
```

| Key | Default | Used by |
| --- | --- | --- |
| `Window` | `10,10,10` | Window body |
| `Panel` | `15,15,15` | Row panels, collapsed module headers |
| `Control` | `20,20,20` | Pills, shells, inputs, tracks |
| `Hover` | `31,31,31` | Row hover, open module header |
| `Divider` | `31,31,31` | Rules and the header separator |
| `Track` | `53,53,53` | The unfilled slider rail |
| `Accent` | `237,237,237` | Active states: hover pill, toggle on, slider fill |
| `Text` | `255,255,255` | Primary text, selected option |
| `TextSoft` | `217,217,217` | Labels, descriptions |
| `TextDim` | `140,140,140` | Group headings, subtitles, carets |
| `Stroke` | `181,181,181` | The focused textbox border |
| `NavActive` | `46,46,46` | Wash behind the selected nav entry |
| `Icon` / `IconActive` | `120,120,120` / `255,255,255` | Tint for asset-id icons |
| `Font` / `FontRegular` / `FontBold` | Gotham SSm | `Font` is Medium weight |

Titles, version strings, the logo, and the font family are all just options — nothing is hardcoded to
the original mockup.

## Rounding and animation

Radii were raised for the redesign. Nothing is `32` any more:

| Element | Radius |
| --- | --- |
| Window | 12 |
| Row panels, module headers, nav entries | 8 |
| Header controls cluster | 8 (the `-` and `X` buttons inside it are 6) |
| Button pill | 10 |
| Toggle track / knob | 12 / 8 |
| Slider track and fill / knob | 3 / 9 |
| TextBox, Keybind, Dropdown shell | 8 |
| Floating dropdown list | 10 (options are 6) |

Every colour, size, rotation and position change is a tween between `0.12s` and `0.28s` with quart or
quint easing, so hover, toggle, slider drag, module expand, dropdown open and window open all animate.
Instant states are only used for the first render and while dragging a slider.

## Notes

- `Design.lua` is the original hand-built Studio mockup this library was rewritten from. It is kept as
  a visual reference, not as working code.
- No external assets. Icons and logos are only drawn when you pass a real asset id, so the library
  itself never depends on an image that might be private or removed.
- Page content lives in a `ScrollingFrame` with `AutomaticCanvasSize`, so components stack by
  `LayoutOrder` instead of fixed coordinates and long pages scroll.
- Row panels draw no borders, so they reach the true left and right edges of the content area.
- Floating dropdown lists live in a full-screen overlay next to the window, which is why they can
  render above it and overflow its edges.
- `Close()` and `Destroy()` disconnect the input connections the window, slider and keybind controls
  registered, so nothing keeps running after the GUI is gone.