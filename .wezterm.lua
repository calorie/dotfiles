local wezterm = require 'wezterm'
return {
  font = wezterm.font('HackGen'),
  font_size = 15.0,
  freetype_load_target = 'Light',
  freetype_render_target = 'HorizontalLcd',
  color_scheme = 'Rosé Pine (base16)',
  window_decorations = 'NONE',
  enable_tab_bar = false,
  use_ime = true,
  adjust_window_size_when_changing_font_size = false,
  window_close_confirmation = 'NeverPrompt',

  colors = {
    cursor_bg = '#c9c8db',
    cursor_fg = '#191724',
    cursor_border = '#c9c8db',
  },

  keys = {
    -- Screen
    {
      key = 'Enter',
      mods = 'CMD',
      action = wezterm.action.ToggleFullScreen,
    },
    -- Close Pane
    {
      key = 'w',
      mods = 'CMD',
      action = wezterm.action.CloseCurrentPane { confirm = false },
    },
    -- Select Pane
    {
      key = '[',
      mods = 'CMD',
      action = wezterm.action.ActivatePaneDirection 'Prev'
    },
    {
      key = ']',
      mods = 'CMD',
      action = wezterm.action.ActivatePaneDirection 'Next'
    },
    -- Split Window
    {
      key = 'd',
      mods = 'CMD',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      key = 'D',
      mods = 'CMD',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
  },
}
