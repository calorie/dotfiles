return {
  {
    'calorie/calorie.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('calorie')
    end,
  },

  {
    'nvim-focus/focus.nvim',
    event = 'BufReadPost',
    init = function()
      local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

      vim.api.nvim_create_autocmd('WinEnter', {
        group = 'MyAutoCmd',
        callback = function(_)
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
          then
            vim.w.focus_disable = true
          else
            vim.w.focus_disable = false
          end
        end,
        desc = 'Disable focus autoresize for BufType',
      })
    end,
    opts = { commands = false, ui = { signcolumn = false } },
  },

  {
    'rebelot/heirline.nvim',
    event = 'VeryLazy',
    config = function()
      local conditions = require('heirline.conditions')
      local utils = require('heirline.utils')

      local function build_highlights()
        local statusline = utils.get_highlight('StatusLine')
        local inactive_statusline = utils.get_highlight('StatusLineNC')
        local normal = utils.get_highlight('Normal')
        local visual = utils.get_highlight('Visual')

        return {
          statusline = { fg = statusline.fg, bg = statusline.bg },
          inactive_statusline = { fg = inactive_statusline.fg, bg = inactive_statusline.bg },
          vi_mode = { fg = normal.fg, bg = visual.bg },
          filename = { fg = statusline.fg, bg = statusline.bg },
          inactive_filename = { fg = inactive_statusline.fg, bg = statusline.bg },
          read_only = { fg = statusline.fg },
          fileinfo = { fg = statusline.fg, bg = statusline.bg },
        }
      end

      local highlights = build_highlights()

      local function filename_provider()
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
        return filename == '' and '[No Name]' or filename
      end

      local function filetype_provider()
        local ft = vim.bo.filetype
        return ft == '' and 'NONE' or string.upper(ft)
      end

      local function fileinfo_encoding_provider()
        local enc = vim.bo.fenc
        if enc == '' then
          enc = vim.o.enc
        end
        return string.upper(enc) .. ' '
      end

      local function is_terminal()
        return conditions.buffer_matches({ buftype = { 'terminal' } })
      end

      local function is_special_filetype()
        return conditions.buffer_matches({ filetype = { 'qf', 'git', 'help' } })
      end

      local function statusline_hl()
        if conditions.is_active() then
          return highlights.statusline
        end
        return highlights.inactive_statusline
      end

      local padding = { provider = ' ' }
      local align = { provider = '%=' }
      local line_info = { provider = '%l:%c ' }
      local scroll_info = { provider = '%P ' }

      local vi_mode = {
        init = function(self)
          self.mode = vim.fn.mode(1)
        end,

        static = {
          mode_names = {
            ['n'] = 'N',
            ['i'] = 'I',
            ['v'] = 'V',
            ['V'] = 'V-L',
            ['\22'] = 'V-B',
            ['R'] = 'R',
            ['c'] = '',
            ['t'] = 'TERM',
          },
        },

        provider = function(self)
          local vi_mode = self.mode_names[self.mode]
          if not vi_mode then return '' end

          return ' ' .. vi_mode .. ' '
        end,

        hl = highlights.vi_mode,
      }

      local filename = {
        hl = highlights.filename,

        padding,

        {
          condition = function() return vim.bo.readonly end,
          provider = '🔒 ',
          hl = highlights.read_only,
        },

        { provider = filename_provider },

        {
          condition = function() return vim.bo.modified end,
          provider = '',
        },
      }

      local inactive_filename = {
        hl = highlights.inactive_filename,

        padding,

        { provider = filename_provider },
      }

      local fileinfo = {
        hl = highlights.fileinfo,

        {
          provider = fileinfo_encoding_provider,
        },

        line_info,

        scroll_info,
      }

      local terminal_statuslines = {
        condition = is_terminal,

        provider = function() return ' TERMINAL' end,
      }

      local filetype = {
        padding,

        {
          provider = filetype_provider,
        },
      }

      local special_statuslines = {
        condition = is_special_filetype,

        filetype,
      }

      local inactive_statuslines = {
        hl = highlights.inactive_statusline,

        condition = conditions.is_not_active,

        inactive_filename,
      }

      local default_statuslines = {
        vi_mode, filename,
        align,
        fileinfo,
      }

      local statuslines = {
        hl = statusline_hl,

        fallthrough = false,

        terminal_statuslines,
        special_statuslines,

        inactive_statuslines,
        default_statuslines,
      }

      require('heirline').setup({ statusline = statuslines })
    end,
  },

  {
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    opts = {
      indent = {
        enable = true,
        -- chars = {
        --   '┊',
        -- },
        style = {
          vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Whitespace')), 'fg', 'gui'),
        },
      }
    },
  },

  {
    'nvim-mini/mini.cursorword',
    version = '*',
    keys = {
      {
        '<space>h',
        function()
          vim.g.minicursorword_disable = not vim.g.minicursorword_disable
          vim.api.nvim_exec_autocmds('CursorMoved', { group = 'MiniCursorword' })
        end,
        mode = 'n', noremap = true, silent = true,
      },
    },
    init = function()
      vim.g.minicursorword_disable = true
    end,
    opts = {},
  },

  -- { 'rktjmp/shipwright.nvim' },
  -- { 'rktjmp/lush.nvim' },
}
