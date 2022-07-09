import os,
       strutils,
       osproc,
       strformat

proc switch(theme: string): void =
  let configDir = getConfigDir()
  let themeDir = configDir & "themes/" & theme & "/"
  if not dirExists(themeDir):
    echo("Theme " & theme & " not found")
    quit 1
  else:
    let files = @["foot/foot.ini", "lite-xl/color.lua", "rofi/colors.rasi",
        "waybar/style.css", "nvim/lua/vapour/user-config/init.lua", "gtk-3.0/settings.ini"]
    for file in files:
      let splitPath = file.split("/")
      if fileExists(configDir & file):
        echo("Removing old " & splitPath[splitPath.len() - 1])
        removeFile(configDir & file)
      createSymlink(themeDir & file, configDir & file)
      echo "Created symlink for " & splitPath[splitPath.len() - 1]
      let histfile = getHomeDir() & ".theme_history"
      writeFile(histfile, theme)
    echo "Theme set to " & theme
    discard execCmd("notify-send -u normal \"Theme Changed\" \"Theme set to " &
        theme & "\"")

proc icon(): string =
  let theme = readFile(getHomeDir() & ".theme_history").strip()
  if theme == "dark-decay":
    return ""
  else:
    return ""

proc toggle(): void =
  let currentTheme = readFile(getHomeDir() & ".theme_history").strip()
  if currentTheme == "dark-decay":
    switch("light-decay")
  else:
    switch("dark-decay")

if paramCount() == 0:
  echo "I need at least one argument"
  quit 1
elif paramStr(1) == "--theme" or paramStr(1) == "-t":
  if paramCount() < 2:
    echo "I need a theme name"
    quit 1
  else:
    switch(paramStr(2))
elif paramStr(1) == "--icon" or paramStr(1) == "-i":
  echo icon()
elif paramStr(1) == "--list" or paramStr(1) == "-l":
  let configDir = getConfigDir()
  let themes = execCmdEx("ls " & getConfigDir() & "themes")[0].split(" ")
  for theme in themes:
    echo theme.strip()
elif paramStr(1) == "--switch" or paramStr(1) == "-s":
  toggle()
elif paramStr(1) == "--help" or paramStr(1) == "-h":
  echo "Usage: theme [--theme <theme>|--icon|--toggle|--list|--help]"
  echo "  --theme <theme> - set theme"
  echo "  --icon          - show current theme icon"
  echo "  --toggle        - switch theme"
  echo "  --list          - list available themes"
  echo "  --help          - show this help"
else:
  echo "Unknown argument"
  echo "Usage: theme [--theme <theme>|--icon|--toggle|--list|--help]"
  echo "  --theme <theme>  - set theme"
  echo "  --icon           - show current theme icon"
  echo "  --toggle         - switch theme"
  echo "  --list           - list available themes"
  echo "  --help           - show this help"
  quit 1








