# color

A lightweight bash utility for colored terminal output. Includes a **`colors`** utility for easy scripting and a **`bg`** utility to quickly switch background colors for dark mode identification across terminals.

## Utilities

- **`colors`** — Apply colors and styles to any script with simple function calls
- **`bg`** — Quickly switch terminal background colors (random, specific, or off) for dark mode

## Features

- **3 Themes**: pastel (default), monokai, oldschool
- **13 Colors**: white, black, red, green, yellow, blue, orange, pink, magenta, purple, silver, gray, cyan
- **Modifiers**: `b:` (bold), `d:` (dim), `u:` (underline)
- **Styled Badges**: success, info, warn, danger, dim

## Installation

### Option 1: Source from a file (Recommended)

Copy `color.sh` to your desired location and add this to your `~/.bashrc` or `~/.zshrc`:

```bash
source /path/to/color.sh
```

### Option 2: Copy directly into your bashrc

Open `color.sh`, copy its contents, and paste them into your `~/.bashrc`.

---

## Usage

### Show demo and usage guide

```bash
color
```

### Change the theme

```bash
color theme pastel   # soft, readable colors (default)
color theme monokai  # vibrant, high contrast
color theme oldschool # classic terminal colors
```

### Background color utility (bg.sh)

When you have many terminal windows open, visually identifying each one can be difficult. `bg.sh` sets a random dark background color, making it easy to distinguish between terminals at a glance.

```bash
./bg.sh       # set a random dark background color
./bg.sh off   # reset to default background
./bg.sh red   # set a specific dark background color
```

Available colors: white, black, red, green, yellow, blue, purple, violet, silver, gray, cyan, magenta, pink, orange, teal, olive, moon, forest, sea, onyx

> **Tip**: Add `source /path/to/bg.sh` to your shell config to use the `bg` command globally.

### Basic text coloring

```bash
echo -e "$(color red "This is red")"
echo -e "$(color green "This is green")"
echo -e "$(color blue "This is blue")"
```

### Use modifiers

```bash
echo -e "$(color b:red "Bold red text")"
echo -e "$(color d:yellow "Dim yellow text")"
echo -e "$(color u:blue "Underlined blue text")"
```

### Background colors (2 arguments = foreground, 3 arguments = foreground + background)

```bash
echo -e "$(color white black "White on black")"
echo -e "$(color yellow blue "Yellow on blue")"
echo -e "$(color b:white d:red "Bold white on dim red bg")"
```

### Styled badges (no arguments = badge only, 2 arguments = badge + message)

```bash
color success "System check passed"
color info "Logs are rotating"
color warn "High memory usage"
color danger "Critical kernel panic"
color dim "Background process idling"

# Badge with message
color success "DEPLOY" "Deployment completed successfully"
color warn "WARNING" "Disk usage above 80%"
color danger "ERROR" "Connection refused"
```

### Available colors

| Color      | Notes |
|------------|-------|
| white      | |
| black      | |
| red        | |
| green      | |
| yellow     | |
| blue       | |
| orange     | |
| pink       | Same as magenta |
| magenta    | Same as pink |
| purple     | |
| silver     | |
| gray       | |
| cyan       | |

### Modifier prefixes

| Prefix | Effect   | Example         |
|--------|----------|-----------------|
| `b:`   | Bold     | `b:red`         |
| `d:`   | Dim      | `d:green`       |
| `u:`   | Underline| `u:blue`        |

**Note**: `b:` and `d:` cannot be combined together (pick one or the other).

---

## Examples

### In a script

```bash
#!/bin/bash
source /path/to/color.sh

color warn "WARNING" "Starting backup process..."
# ... backup logic ...
color success "OK" "Backup completed"
```

### Mixed styling

```bash
echo -e "$(color b:white d:blue "Bold white on dim blue")"
```

### Theme switching

```bash
color theme monokai
echo -e "$(color red "In monokai theme")"
color theme pastel
echo -e "$(color red "Back to pastel theme")"
```

---

## Requirements

- Bash 4.0+
- Terminal with ANSI color support (most modern terminals)

---

## License

This project is licensed under the [**MIT License**](LICENSE.md).

---

<div align="center">
  <img alt="JREAM" src="https://jream.com/jream.jpg" />

&copy;2016 Jesse Boyer [JREAM]([JREAM](https://jream.com))

</div>

