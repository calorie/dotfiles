local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
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
    'feline-nvim/feline.nvim',
    event = 'VeryLazy',
    config = function()
      local vi_mode = require('feline.providers.vi_mode')

      local base = '#191724'
      local surface = '#25232e'
      local muted = '#6e6a86'
      local subtle = '#908caa'
      local text = '#c9c8db'
      local love = '#d66B7f'
      local gold = '#f3cc95'
      local rose = '#ebbcba'
      local pine = '#31748f'
      local foam = '#9ccfd8'
      local iris = '#c4a7e7'
      local blue_gray = '#8ac6f2'
      local highlight_med = '#403d52'

      local vi_mode_text = {
        NORMAL = 'N',
        OP = 'OP',
        INSERT = 'I',
        VISUAL = 'V',
        LINES = 'V-L',
        BLOCK = 'V-B',
        REPLACE = 'R',
        ['V-REPLACE'] = 'V-R',
        ENTER = 'ENTER',
        MORE = 'MORE',
        SELECT = 'S',
        COMMAND = '',
        SHELL = 'SHELL',
        TERM = 'TERM',
        NONE = 'NONE',
        CONFIRM = 'CONFIRM',
      }

      local inactive_filetypes = {
        '^fern$',
        '^fugitiveblame$',
        '^qf$',
        '^git$',
        '^fugitive$',
        '^help$',
      }

      require('feline').setup({
        theme = {
          fg = subtle,
          bg = surface,
          black = base,
          yellow = gold,
          cyan = foam,
          oceanblue = blue_gray,
          green = pine,
          orange = rose,
          violet = iris,
          magenta = love,
          white = text,
          skyblue = blue_gray,
          red = love,
          muted = muted,
          text = text,
          highlight_med = highlight_med,
        },
        default_fg = subtle,
        default_bg = surface,
        vi_mode_colors = {
          NORMAL = 'fg',
          OP = 'fg',
          INSERT = 'fg',
          CONFIRM = 'fg',
          VISUAL = 'fg',
          LINES = 'fg',
          BLOCK = 'fg',
          REPLACE = 'fg',
          ['V-REPLACE'] = 'fg',
          ENTER = 'fg',
          MORE = 'fg',
          SELECT = 'fg',
          COMMAND = 'fg',
          SHELL = 'fg',
          TERM = 'fg',
          NONE = 'fg',
        },
        components = {
          active = {
            {
              {
                provider = function()
                  return vi_mode_text[vi_mode.get_vim_mode()]
                end,
                hl = {
                  fg = 'text',
                  bg = 'highlight_med',
                },
                left_sep = {
                  str = ' ',
                  hl = {
                    fg = 'text',
                    bg = 'highlight_med',
                  }
                },
                right_sep = {
                  str = ' ',
                  hl = {
                    fg = 'text',
                    bg = 'highlight_med',
                  }
                },
              },
              {
                provider = {
                  name = 'file_info',
                  opts = {
                    type = 'relative',
                    file_modified_icon = '',
                    file_readonly_icon = '🔒 ',
                  },
                },
                hl = {
                  fg = 'fg',
                  bg = 'bg',
                },
                left_sep = ' ',
                icon = '',
              },
            },
            {
              {
                provider = 'file_encoding',
                hl = {
                  fg = 'fg',
                  bg = 'bg',
                },
                right_sep = ' ',
              },
              {
                provider = 'position',
                hl = {
                  fg = 'fg',
                  bg = 'bg',
                },
                right_sep = ' ',
              },
              {
                provider = 'line_percentage',
                hl = {
                  fg = 'fg',
                  bg = 'bg',
                },
                right_sep = ' ',
              },
            },
          },
          inactive = {
            {
              {
                provider = {
                  name = 'file_info',
                  opts = {
                    type = 'relative',
                    file_modified_icon = '',
                    file_readonly_icon = '',
                  },
                },
                hl = {
                  fg = 'muted',
                  bg = 'bg',
                },
                left_sep = ' ',
                icon = '',
              },
            },
            {},
          },
        },
        conditional_components = {
          {
            condition = function()
              local ft = vim.api.nvim_buf_get_option(0, 'filetype')
              for _, v in ipairs(inactive_filetypes) do
                  if ft:match(v) then
                      return true
                  end
              end
              return false
            end,
            active = {},
            inactive = {
              {
                {
                  provider = 'file_type',
                  hl = {
                    fg = 'muted',
                    bg = 'bg',
                  },
                  left_sep = ' ',
                },
              },
            },
          },
        },
        force_inactive = {
          filetypes = inactive_filetypes,
          buftypes = {
            '^terminal$',
          },
          bufnames = {},
        },
      })
    end,
  },

  {
    'ethanholz/nvim-lastplace',
    event = 'BufReadPre',
    config = function()
      require('nvim-lastplace').setup {}
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    -- dependencies = 'nvim-tree/nvim-web-devicons',
    cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFocus' },
    event = 'VimEnter',
    keys = {
      { '<leader>nt', '<cmd>NvimTreeToggle<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>nf', '<cmd>NvimTreeFindFile<cr>', mode = 'n', noremap = true, silent = true },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local nt_api = require("nvim-tree.api")

      local function open_nvim_tree(data)
        if vim.fn.filereadable(data.file) == 1 then
          return
        end

        nt_api.tree.focus()
      end

      vim.api.nvim_create_autocmd('VimEnter', {
        group = 'MyAutoCmd',
        nested = true,
        callback = open_nvim_tree,
      })

      vim.api.nvim_create_autocmd('TabNewEntered', {
        group = 'MyAutoCmd',
        nested = true,
        callback = function()
          nt_api.tree.focus()
        end,
      })

      -- nvim-tree is also there in modified buffers so this function filter it out
      local modifiedBufs = function(bufs)
        local t = 0
        for k,v in pairs(bufs) do
          if v.name:match("NvimTree_") == nil then
            t = t + 1
          end
        end
        return t
      end

      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and
          vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil and
          modifiedBufs(vim.fn.getbufinfo({bufmodified = 1})) == 0 then
            vim.cmd "quit"
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
            show = {
              file = false,
              folder = false,
              folder_arrow = false,
              git = false,
              modified = false,
            },
            glyphs = {
              default = '',
              symlink = '',
            },
          },
          special_files = {},
          root_folder_label = false,
        },
        filters = {
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
      })
    end,
  },

  {
    'beauwilliams/focus.nvim',
    event = 'VimEnter',
    init = function()
      local ignore_filetypes = { 'NvimTree' }
      local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

      local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })

      vim.api.nvim_create_autocmd('WinEnter', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
            vim.b.focus_disable = true
          end
        end,
        desc = 'Disable focus autoresize for BufType',
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
          end
        end,
        desc = 'Disable focus autoresize for FileType',
      })
    end,
    config = function()
      require("focus").setup({ ui = { signcolumn = false } })
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufRead',
    config = function()
      vim.g.indent_blankline_char = '┊'
      require('indent_blankline').setup {}
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = 'nvim-lua/plenary.nvim',
    cmd = 'Telescope',
    keys = {
      { '<space>f', '<cmd>Telescope find_files<cr>', mode = 'n', noremap = true },
      { '<space>g', '<cmd>Telescope live_grep<cr>', mode = 'n', noremap = true },
      { '<space>b', '<cmd>Telescope buffers<cr>', mode = 'n', noremap = true },
    },
    config = function()
      require('telescope').setup {
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
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
        }
      }
    end,
  },

  -- ------------------------------------
  --  Color
  -- ------------------------------------
  {
    'calorie/calorie.nvim',
    dependencies = 'rktjmp/lush.nvim',
    config = function()
      vim.opt.termguicolors = true
      vim.cmd([[colorscheme calorie]])
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPre',
    build = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
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

      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
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
      {
        'L3MON4D3/LuaSnip',
        dependencies = 'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip/loaders/from_vscode').lazy_load({ paths = { vim.fn.stdpath('data') .. '/lazy/friendly-snippets' } })
        end,
      },
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
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },

  -- ------------------------------------
  --  Edit
  -- ------------------------------------
  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gcc', '<Plug>(comment_toggle_linewise_current)', mode = 'n', noremap = true, silent = true },
      { 'gc', '<Plug>(comment_toggle_linewise_visual)', mode = 'v', noremap = true, silent = true },
    },
    config = function()
      require('Comment').setup {}
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}

      vim.api.nvim_set_keymap('i', '<C-b>', 'v:lua.MPairs.autopairs_bs()', { expr = true, noremap = true })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = 'hrsh7th/cmp-nvim-lsp',
    config = function()
      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig/util'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, bufopts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      end

      lspconfig.gopls.setup {
        cmd = { 'gopls', 'serve' },
        filetypes = { 'go', 'gomod' },
        root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }
      lspconfig.jsonls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }
      lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }
      lspconfig.sqlls.setup {
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
        capabilities = capabilities,
        on_attach = on_attach,
      }
      lspconfig.solargraph.setup {
        init_options = { diagnostics = true },
        capabilities = capabilities,
        on_attach = on_attach,
      }
      lspconfig.terraformls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }
      -- lspconfig.tsserver.setup {
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- }
      lspconfig.yamlls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
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
      }
      lspconfig.jdtls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }
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
    'godlygeek/tabular',
    cmd = { 'Tabularize', 'AddTabularPipeline' },
    keys = {
      { 'tb', ':Tabularize /', mode = 'v', noremap = true },
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

  -- {
  --   'brglng/vim-im-select',
  --   event = 'InsertEnter',
  --   init = function()
  --     vim.g.im_select_default = 'com.google.inputmethod.Japanese.Roman'
  --   end,
  -- },

  {
    'tpope/vim-surround',
    keys = {
      { 'ds', '<Plug>Dsurround', mode = 'n', noremap = true },
      { 'cs', '<Plug>Csurround', mode = 'n', noremap = true },
      { 'S', '<Plug>VSurround', mode = 'x', noremap = true },
      { 'gS', '<Plug>VgSurround', mode = 'x', noremap = true },
      '<Plug>Yssurround', '<Plug>YSsurround',
      '<Plug>Ysurround', '<Plug>YSurround',
    },
    init = function()
      local char2nr = vim.fn.char2nr
      vim.g['surround_' .. char2nr('e')] = "begin \r end"
      vim.g['surround_' .. char2nr('d')] = "do \r end"
      vim.g['surround_' .. char2nr('-')] = ":\r"
    end,
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
    config = function()
      require('yanky').setup({
        highlight = {
          on_put = false,
          on_yank = false,
        },
      })
    end,
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
    'rhysd/ghpr-blame.vim',
    cmd = { 'GHPRBlame', 'GHPRBlameQuit' },
    init = function()
      vim.g.ghpr_github_auth_token = os.getenv('GITHUB_TOKEN')
    end,
  },

  {
    'glepnir/lspsaga.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    event = 'BufRead',
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
    event = 'BufRead',
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
    'tpope/vim-fugitive',
    cmd = 'Git',
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
