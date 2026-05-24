return {
  {
    'pocco81/auto-save.nvim',
    event = { 'TextChanged', 'TextChangedI' },
    opts = {
      enabled = true,
      execution_message = {
        message = '',
        dim = 0,
        cleaning_interval = 0,
      },
      condition = function(buf)
        local fn = vim.fn
        local utils = require('auto-save.utils.data')

        if
          fn.getbufvar(buf, '&modifiable') == 1 and
          utils.not_in(fn.getbufvar(buf, '&filetype'), { 'minifiles' }) then
          return true
        end
        return false
      end,
    },
  },

  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gcc', '<Plug>(comment_toggle_linewise_current)', mode = 'n', noremap = true, silent = true },
      { 'gc', '<Plug>(comment_toggle_linewise_visual)', mode = 'x', noremap = true, silent = true },
    },
    opts = {},
  },

  {
    'keaising/im-select.nvim',
    event = 'InsertLeave',
    opts = {
      default_im_select = 'com.google.inputmethod.Japanese.Roman',
      set_previous_events = {},
      async_switch_im = true,
    },
  },

  {
    'nvim-mini/mini.ai',
    version = '*',
    keys = {
      { 'ae', function() require('mini.ai').select_textobject('a', 'e') end, mode = 'x' },
      { 'ae', function() require('mini.ai').select_textobject('a', 'e', { operator_pending = true }) end, mode = 'o' },
    },
    opts = {
      custom_textobjects = {
        e = function()
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line('$'),
            col = math.max(vim.fn.getline('$'):len(), 1),
          }

          return { from = from, to = to, vis_mode = 'V' }
        end,
      },
      mappings = {
        around = '',
        inside = '',
        around_next = '',
        inside_next = '',
        around_last = '',
        inside_last = '',
        goto_left = '',
        goto_right = '',
      },
    },
  },

  {
    'nvim-mini/mini.align',
    version = '*',
    keys = {
      { 'tb', mode = { 'n', 'v' } },
    },
    opts = {
      mappings = {
        start = 'tb',
        start_with_preview = '',
      },
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}

      vim.api.nvim_set_keymap('i', '<C-b>', "v:lua.require'nvim-autopairs'.autopairs_bs()", { expr = true, noremap = true })
    end,
  },

  {
    'kylechui/nvim-surround',
    keys = {
      { 'ys', '<Plug>(nvim-surround-normal)', mode = 'n', noremap = true },
      { 'yss', '<Plug>(nvim-surround-normal-cur)', mode = 'n', noremap = true },
      { '<C-g>s', '<Plug>(nvim-surround-insert)', mode = 'i', noremap = true },
      { 'S', '<Plug>(nvim-surround-visual)', mode = 'x', noremap = true },
      { 'ds', '<Plug>(nvim-surround-delete)', mode = 'n', noremap = true },
      { 'cs', '<Plug>(nvim-surround-change)', mode = 'n', noremap = true },
    },
    opts = {},
  },

  {
    'AndrewRadev/switch.vim',
    keys = {
      { '+', function() vim.fn['switch#Switch']() end, mode = 'n', noremap = true, silent = true },
      { '-', function() vim.fn['switch#Switch']({ definitions = vim.g.variable_style_switch_definitions }) end, mode = 'n', noremap = true, silent = true },
    },
    init = function()
      vim.g.switch_custom_definitions = {
        { '+', '-' },
        { '*', '/' },
        { 'and', 'or' },
        { 'yes', 'no' },
        { 'if', 'unless' },
        { 'enable', 'disable' },
        { 'pick', 'reword', 'fixup', 'squash', 'edit', 'exec' },
      }
      vim.g.variable_style_switch_definitions = {
        {
          ["\\<[a-z0-9]\\+_\\k\\+\\>"] = {
            ["_\\(.\\)"] = "\\U\\1",
          },
        },
        {
          ["\\<[a-z0-9]\\+[A-Z]\\k\\+\\>"] = {
            ["\\([A-Z]\\)"] = "_\\l\\1",
          },
        },
      }
    end,
  },

  {
    'Wansmer/treesj',
    keys = {
      { '<space>m', '<cmd>TSJToggle<cr>', mode = 'n', noremap = true, silent = true },
    },
    opts = {
      use_default_keymaps = false,
      notify = false,
      langs = {},
    },
  },

  {
    'lambdalisue/vim-suda',
    cmd = { 'SudaRead', 'SudaWrite' },
  },

  {
    't9md/vim-textmanip',
    keys = {
      { '<C-h>', '<Plug>(textmanip-move-left)', mode = 'x', noremap = true },
      { '<C-j>', '<Plug>(textmanip-move-down)', mode = 'x', noremap = true },
      { '<C-k>', '<Plug>(textmanip-move-up)', mode = 'x', noremap = true },
      { '<C-l>', '<Plug>(textmanip-move-right)', mode = 'x', noremap = true },
    },
  },

  {
    'gbprod/yanky.nvim',
    keys = {
      { 'p', '<Plug>(YankyPutAfter)', mode = 'n', noremap = true },
      { 'p', '<Plug>(YankyPutBefore)', mode = 'x', noremap = true },
      { 'P', '<Plug>(YankyPutBefore)', mode = {'n', 'x'}, noremap = true },
      { '<C-p>', '<Plug>(YankyCycleForward)', mode = 'n', noremap = true },
      { '<C-n>', '<Plug>(YankyCycleBackward)', mode = 'n', noremap = true },
      { 'y', '<Plug>(YankyYank)', mode = {'n', 'x'}, noremap = true },
    },
    opts = {
      highlight = {
        on_put = false,
        on_yank = false,
      },
      picker = {
        telescope = {
          use_default_mappings = false,
        },
      },
    },
  },
}
