local wezterm = require 'wezterm'

local palette = {
  base = '#191724',
  overlay = '#26233a',
  text = '#c9c8db',
  love = '#d66B7f',
  gold = '#f3cc95',
  rose = '#ebbcba',
  pine = '#31748f',
  foam = '#9ccfd8',
  iris = '#c4a7e7',
}

return {
  font = wezterm.font('HackGen'),
  font_size = 15.0,
  freetype_load_target = 'Light',
  freetype_render_target = 'HorizontalLcd',
  color_scheme = 'Rosé Pine (base16)',
  window_decorations = 'NONE',
  enable_tab_bar = false,
  enable_scroll_bar = false,
  use_ime = true,
  adjust_window_size_when_changing_font_size = false,
  window_close_confirmation = 'NeverPrompt',

  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },

  colors = {
    foreground = palette.text,
    cursor_bg = palette.text,
    cursor_fg = palette.base,
    cursor_border = palette.text,
    ansi = {
      palette.overlay,
      palette.love,
      palette.pine,
      palette.gold,
      palette.foam,
      palette.iris,
      palette.rose,
      palette.text,
    },
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
