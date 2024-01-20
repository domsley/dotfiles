local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Hide UI tab
config.enable_tab_bar = false

-- Font
config.font_size = 13.0
config.font = wezterm.font("Liga SFMono Nerd Font")

-- Colors
config.color_scheme = "Ir Black"

-- Execute tmux in WSL
config.default_prog = { "~" }

config.exit_behavior = "Close"

-- and finally, return the configuration to wezterm
return config
