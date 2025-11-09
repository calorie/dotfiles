vim.loader.enable()

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", 'ErrorMsg' },
      { out, 'WarningMsg' },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 'T', api.node.open.tab, opts('Open: New Tab'))
  vim.keymap.set('n', 'r', api.tree.reload, opts('Refresh'))
  vim.keymap.set('n', 'R', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'p', api.node.navigate.sibling.first, opts('First Sibling'))
  vim.keymap.set('n', '<C-v>', api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', 'Y', api.fs.copy.filename, opts('Copy Name'))
end

require('lazy').setup({
  -- ------------------------------------
  --  Buffer
  -- ------------------------------------
  {
    'rebelot/heirline.nvim',
    event = 'VeryLazy',
    config = function()
      local conditions = require('heirline.conditions')
      local utils = require('heirline.utils')

      local colors = {
        subtle = utils.get_highlight('StatusLine').fg,
        surface = utils.get_highlight('StatusLine').bg,
        muted = utils.get_highlight('StatusLineNC').fg,
        base = utils.get_highlight('StatusLineNC').bg,
        text = utils.get_highlight('Normal').fg,
        highlight_med = utils.get_highlight('Visual').bg,
      }

      local highlights = {
        statusline = { fg = colors.subtle, bg = colors.surface },
        inactive_statusline = { fg = colors.muted, bg = colors.base },
        vi_mode = { fg = colors.text, bg = colors.highlight_med },
        filename = { fg = colors.subtle, bg = colors.surface },
        inactive_filename = { fg = colors.muted, bg = colors.surface },
        read_only = { fg = colors.subtle },
        fileinfo = { fg = colors.subtle, bg = colors.surface },
      }

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

      local filename_provider = function()
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
        if filename == '' then return '[No Name]' end

        return filename
      end

      local filename = {
        hl = highlights.filename,

        { provider = ' ' },

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

        { provider = ' ' },

        { provider = filename_provider },
      }

      local align = { provider = '%=' }

      local fileinfo = {
        hl = highlights.fileinfo,

        {
          provider = function()
            local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
            return enc:upper() .. ' '
          end,
        },

        { provider = '%l:%c ' },

        { provider = '%P ' },
      }

      local is_terminal = function()
        return conditions.buffer_matches({ buftype = { 'terminal' } })
      end

      local terminal_statuslines = {
        condition = is_terminal,

        provider = function() return ' TERMINAL' end,
      }

      local is_special_filetype = function()
        return conditions.buffer_matches({ filetype = { 'NvimTree', 'qf', 'git', 'help' } })
      end

      local filetype = {
        { provider = ' ' },

        {
          provider = function()
            local ft = vim.bo.filetype
            return ft == '' and 'NONE' or string.upper(ft)
          end,
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
        hl = function()
          if conditions.is_active() then
              return highlights.statusline
          else
              return highlights.inactive_statusline
          end
        end,

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
    'vladdoster/remember.nvim',
    event = 'BufReadPre',
    config = function()
      require('remember').setup {}
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFocus' },
    keys = {
      { '<leader>nt', '<cmd>NvimTreeToggle<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>nf', '<cmd>NvimTreeFindFile<cr>', mode = 'n', noremap = true, silent = true },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local function open_nvim_tree(data)
        if vim.fn.filereadable(data.file) == 1 then
          return
        end

        require('nvim-tree.api').tree.open({
          path = nil,
          current_window = false,
          find_file = false,
          update_root = false,
        })
      end

      vim.api.nvim_create_autocmd('VimEnter', {
        group = 'MyAutoCmd',
        nested = true,
        callback = open_nvim_tree,
      })

      vim.api.nvim_create_autocmd('TabNewEntered', {
        group = 'MyAutoCmd',
        nested = true,
        callback = open_nvim_tree,
      })

      -- nvim-tree is also there in modified buffers so this function filter it out
      local modifiedBufs = function(bufs)
        local t = 0
        for k,v in pairs(bufs) do
          if v.name:match('NvimTree_') == nil then
            t = t + 1
          end
        end
        return t
      end

      vim.api.nvim_create_autocmd('BufEnter', {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and
          vim.api.nvim_buf_get_name(0):match('NvimTree_') ~= nil and
          modifiedBufs(vim.fn.getbufinfo({bufmodified = 1})) == 0 then
            vim.cmd 'quit'
          end
        end
      })
    end,
    config = function()
      require('nvim-tree').setup({
        on_attach = on_attach,
        git = {
          enable = false,
        },
        diagnostics = {
          enable = false,
        },
        modified = {
          enable = false,
        },
        tab = {
          sync = {
            open = true,
          },
        },
        view = {
          width = 23,
        },
        renderer = {
          icons = {
            web_devicons = {
              file = {
                enable = false,
              },
            },
            show = {
              file = false,
              folder = false,
              folder_arrow = false,
              git = false,
              modified = false,
              diagnostics = false,
            },
            glyphs = {
              bookmark = '+',
              symlink = '',
            },
          },
          special_files = {},
          root_folder_label = false,
        },
        filters = {
          git_ignored = false,
          custom = { '^\\.git$', '.DS_Store' },
        },
        actions = {
          open_file = {
            resize_window = false,
            window_picker = {
              enable = false,
            },
          },
        },
        hijack_directories = {
          enable = false,
          auto_open = false,
        },
        notify = {
          threshold = vim.log.levels.ERROR,
        },
      })
    end,
  },

  {
    'nvim-focus/focus.nvim',
    event = 'BufReadPost',
    init = function()
      local ignore_filetypes = { 'NvimTree' }
      local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

      local augroup =
        vim.api.nvim_create_augroup('FocusDisable', { clear = true })

      vim.api.nvim_create_autocmd('WinEnter', {
        group = augroup,
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

      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
          else
            vim.b.focus_disable = false
          end
        end,
        desc = 'Disable focus autoresize for FileType',
      })
    end,
    config = function()
      require('focus').setup({ commands = false, ui = { signcolumn = false } })
    end,
  },

  {
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('hlchunk').setup {
        indent = {
          enable = true,
          chars = {
            '┊',
          },
          style = {
            vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Whitespace')), 'fg', 'gui'),
          },
        }
      }
    end
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-frecency.nvim' },
    cmd = 'Telescope',
    keys = {
      { '<space>f', '<cmd>Telescope find_files<cr>', mode = 'n', noremap = true },
      { '<space>g', '<cmd>Telescope live_grep<cr>', mode = 'n', noremap = true },
      { '<space>b', '<cmd>Telescope buffers<cr>', mode = 'n', noremap = true },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ['<C-o>'] = 'file_edit',
              ['<C-s>'] = 'file_split',
              ['<C-l>'] = 'file_vsplit',
              ['<C-j>'] = 'move_selection_next',
              ['<C-k>'] = 'move_selection_previous',
            }
          },
          layout_config = {
            prompt_position = 'top',
          },
          sorting_strategy = 'ascending',
        },
        extensions = {
          frecency = {
            use_sqlite = false,
          }
        },
      }
      telescope.load_extension 'frecency'
    end,
  },

  -- ------------------------------------
  --  Color
  -- ------------------------------------
  {
    'calorie/calorie.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd([[colorscheme calorie]])
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    -- dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'BufReadPre',
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          'go', 'hcl', 'html', 'javascript', 'json', 'lua', 'ruby', 'java',
          'markdown', 'markdown_inline', 'rust', 'sql', 'vim', 'yaml', 'c',
        },
        highlight = {
          enable = true,
          disable = { 'ruby' },
        },
        indent = {
          enable = true,
        },
      }

      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
  },

  -- ------------------------------------
  --  Completion
  -- ------------------------------------
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      {
        'L3MON4D3/LuaSnip',
        dependencies = {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
        version = 'v2.*',
        build = 'make install_jsregexp',
      },
      {
        'zbirenbaum/copilot-cmp',
        dependencies = 'zbirenbaum/copilot.lua',
        config = function ()
          require('copilot_cmp').setup()
        end
      },
      'windwp/nvim-autopairs',
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "copilot", group_index = 2 },
          { name = 'nvim_lsp', group_index = 2 },
          { name = 'luasnip', group_index = 2 },
        }, {
          { name = 'buffer' },
        })
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },

  -- ------------------------------------
  --  Edit
  -- ------------------------------------
  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gcc', '<Plug>(comment_toggle_linewise_current)', mode = 'n', noremap = true, silent = true },
      { 'gc', '<Plug>(comment_toggle_linewise_visual)', mode = 'x', noremap = true, silent = true },
    },
    config = function()
      require('Comment').setup {}
    end,
  },

  {
    'zbirenbaum/copilot.lua',
    dependencies = 'copilotlsp-nvim/copilot-lsp',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
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
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = 'hrsh7th/cmp-nvim-lsp',
    init = function()
      vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        pattern = { '*.tf', '*.tfvars' },
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end,
    config = function()
      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, bufopts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('*', {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config('gopls', {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })
      vim.lsp.enable('gopls')

      vim.lsp.enable('jsonls')

      vim.lsp.enable('rust_analyzer')

      vim.lsp.config('sqlls', {
        settings = {
          sqls = {
            connections = {
              -- {
              --   driver = 'mysql',
              --   dataSourceName = 'root:root@tcp(127.0.0.1:13306)/world',
              -- },
            },
          },
        },
      })
      vim.lsp.enable('sqlls')

      vim.lsp.config('solargraph', {
        init_options = { diagnostics = true },
      })
      vim.lsp.enable('solargraph')

      vim.lsp.config('terraformls', {
        init_options = {
          ignoreSingleFileWarning = true
        }
      })
      vim.lsp.enable('terraformls')

      vim.lsp.config('tsserver', {})
      vim.lsp.enable('tsserver')

      vim.lsp.config('yamlls', {
        settings = {
          yaml = {
            customTags = {
              '!fn',
              '!And',
              '!And sequence',
              '!If',
              '!If sequence',
              '!Not',
              '!Not sequence',
              '!Equals',
              '!Equals sequence',
              '!Or',
              '!Or sequence',
              '!FindInMap',
              '!FindInMap sequence',
              '!Base64',
              '!Cidr',
              '!Ref',
              '!Ref Scalar',
              '!Sub',
              '!Sub sequence',
              '!GetAtt',
              '!GetAZs',
              '!ImportValue',
              '!ImportValue sequence',
              '!Select',
              '!Select sequence',
              '!Split',
              '!Split sequence',
              '!Join',
              '!Join sequence',
            },
          },
        },
      })
      vim.lsp.enable('yamlls')

      vim.lsp.enable('jdtls')
    end,
  },

  {
    'AndrewRadev/switch.vim',
    cmd = 'Switch',
    keys = {
      { '+', '<cmd>Switch<cr>', mode = 'n', noremap = true, silent = true },
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
    'junegunn/vim-easy-align',
    cmd = { 'EasyAlign' },
    keys = {
      { 'tb', '<Plug>(EasyAlign)', mode = 'n', noremap = true },
      { 'tb', '<Plug>(EasyAlign)', mode = 'v', noremap = true },
    },
  },

  {
    'Wansmer/treesj',
    cmd = { 'TSJToggle' },
    keys = {
      { '<space>m', '<cmd>TSJToggle<cr>', mode = 'n', noremap = true, silent = true },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
        notify = false,
      })
    end,
  },

  {
    'keaising/im-select.nvim',
    event = 'InsertLeave',
    config = function()
      require('im_select').setup({
        default_im_select = 'com.google.inputmethod.Japanese.Roman',
        set_previous_events = {},
        async_switch_im = true,
      })
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
    config = function()
      require('nvim-surround').setup {}
    end
  },

  {
    'gbprod/yanky.nvim',
    keys = {
      { 'p', '<Plug>(YankyPutAfter)', mode = {'n', 'x'}, noremap = true },
      { 'P', '<Plug>(YankyPutBefore)', mode = {'n', 'x'}, noremap = true },
      { 'gp', '<Plug>(YankyGPutAfter)', mode = {'n', 'x'}, noremap = true },
      { 'gP', '<Plug>(YankyGPutBefore)', mode = {'n', 'x'}, noremap = true },
      { '<C-p>', '<Plug>(YankyCycleForward)', mode = 'n', noremap = true },
      { '<C-n>', '<Plug>(YankyCycleBackward)', mode = 'n', noremap = true },
      { 'y', '<Plug>(YankyYank)', mode = {'n', 'x'}, noremap = true },
    },
    opts = {
      highlight = {
        on_put = false,
        on_yank = false,
      },
    },
  },

  -- ------------------------------------
  --  Search/Move
  -- ------------------------------------
  {
    'rhysd/clever-f.vim',
    keys = {
      { 'f', '<Plug>(clever-f-f)', mode = 'n', noremap = true },
      { 'F', '<Plug>(clever-f-F)', mode = 'n', noremap = true },
    },
  },

  {
    'phaazon/hop.nvim',
    cmd = { 'HopVerticalAC', 'HopVerticalBC' },
    keys = {
      { '<leader>j', '<cmd>HopVerticalAC<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>k', '<cmd>HopVerticalBC<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>h', '<cmd>HopWord<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>l', '<cmd>HopWordMW<cr>', mode = 'n', noremap = true, silent = true },
    },
    config = function()
      require('hop').setup {}
    end,
  },

  {
    'terryma/vim-expand-region',
    keys = {
      { '<space>', '<Plug>(expand_region_expand)', mode = 'v', noremap = true },
      { '<bs>', '<Plug>(expand_region_shrink)', mode = 'v', noremap = true },
    },
  },

  {
    't9md/vim-quickhl',
    keys = {
      { '<space>h', '<Plug>(quickhl-cword-toggle)', mode = 'n', noremap = true },
    },
    config = function()
      vim.g.quickhl_cword_hl_command = 'link QuickhlCword SpellCap'
    end,
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

  -- ------------------------------------
  --  textobj
  -- ------------------------------------
  {
    'kana/vim-textobj-entire',
    dependencies = 'kana/vim-textobj-user',
    keys = {
      { 'ae', '<Plug>(textobj-entire-a)', mode = 'x', noremap = true },
      { 'ie', '<Plug>(textobj-entire-i)', mode = 'x', noremap = true },
    },
  },

  {
    'kana/vim-textobj-indent',
    dependencies = 'kana/vim-textobj-user',
    keys = {
      { 'ai', '<Plug>(textobj-indent-a)', mode = 'x', noremap = true },
      { 'ii', '<Plug>(textobj-indent-i)', mode = 'x', noremap = true },
      { 'aI', '<Plug>(textobj-indent-same-a)', mode = 'x', noremap = true },
      { 'iI', '<Plug>(textobj-indent-same-i)', mode = 'x', noremap = true },
    },
  },

  -- ------------------------------------
  --  Utility
  -- ------------------------------------
  {
    'yetone/avante.nvim',
    cmd = { 'AvanteAsk' },
    opts = {
      provider = 'copilot',
    },
    build = 'make',
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'hrsh7th/nvim-cmp',
      'zbirenbaum/copilot.lua',
    },
  },
  {
    'rhysd/ghpr-blame.vim',
    cmd = { 'GHPRBlame', 'GHPRBlameQuit' },
    init = function()
      vim.g.ghpr_github_auth_token = os.getenv('GITHUB_TOKEN')
    end,
  },

  {
    'glepnir/lspsaga.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    keys = {
      { '<leader>ca', '<cmd>Lspsaga code_action<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>ca', '<cmd><C-U>Lspsaga range_code_action<cr>', mode = 'v', noremap = true, silent = true },
      { 'K', '<cmd>Lspsaga peek_definition<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>o', '<cmd>Lspsaga outline<cr>', mode = 'n', noremap = true, silent = true },
      { 'gd', '<cmd>Lspsaga hover_doc<cr>', mode = 'n', noremap = true, silent = true },
    },
    config = function()
      require('lspsaga').setup {
        symbol_in_winbar = {
          enable = false,
        },
        lightbulb = {
          enable = false,
        },
      }
    end,
  },

  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = 'sh -c "if command -v yarn >/dev/null 2>&1; then cd app && yarn install; fi"',
  },

  {
    'lambdalisue/suda.vim',
    cmd = { 'SudaRead', 'SudaWrite' },
  },

  {
    'Pocco81/auto-save.nvim',
    event = { 'InsertEnter', 'TextChanged' },
    config = function()
      require('auto-save').setup {
        enabled = true,
        execution_message = {
          message = '',
        },
      }
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    cmd = 'Gitsigns',
    keys = {
      { '<leader>bl', '<cmd>Gitsigns toggle_current_line_blame<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>di', '<cmd>Gitsigns toggle_signs<cr>', mode = 'n', noremap = true, silent = true },
    },
    config = function()
      require('gitsigns').setup {
        signcolumn = false,
        current_line_blame_formatter = '<abbrev_sha> <author>, <author_time:%Y-%m-%d> - <summary>',
      }
    end,
  },

  {
    'thinca/vim-quickrun',
    keys = {
      { '<leader>r', '<cmd>QuickRun<cr>', mode = 'n', noremap = true, silent = true },
    },
  },
})

vim.cmd([[
  syntax enable
  filetype plugin indent on
]])

vim.opt.secure = true
