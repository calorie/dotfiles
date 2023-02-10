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
        NORMAL        = 'N',
        OP            = 'OP',
        INSERT        = 'I',
        VISUAL        = 'V',
        LINES         = 'V-L',
        BLOCK         = 'V-B',
        REPLACE       = 'R',
        ['V-REPLACE'] = 'V-R',
        ENTER         = 'ENTER',
        MORE          = 'MORE',
        SELECT        = 'S',
        COMMAND       = '',
        SHELL         = 'SHELL',
        TERM          = 'TERM',
        NONE          = 'NONE',
        CONFIRM       = 'CONFIRM'
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
          fg            = subtle,
          bg            = surface,
          black         = base,
          yellow        = gold,
          cyan          = foam,
          oceanblue     = blue_gray,
          green         = pine,
          orange        = rose,
          violet        = iris,
          magenta       = love,
          white         = text,
          skyblue       = blue_gray,
          red           = love,
          muted         = muted,
          text          = text,
          highlight_med = highlight_med,
        },
        default_fg = subtle,
        default_bg = surface,
        vi_mode_colors = {
          NORMAL        = 'fg',
          OP            = 'fg',
          INSERT        = 'fg',
          CONFIRM       = 'fg',
          VISUAL        = 'fg',
          LINES         = 'fg',
          BLOCK         = 'fg',
          REPLACE       = 'fg',
          ['V-REPLACE'] = 'fg',
          ENTER         = 'fg',
          MORE          = 'fg',
          SELECT        = 'fg',
          COMMAND       = 'fg',
          SHELL         = 'fg',
          TERM          = 'fg',
          NONE          = 'fg'
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
                    bg = 'highlight_med'
                  }
                },
                right_sep = {
                  str = ' ',
                  hl = {
                    fg = 'text',
                    bg = 'highlight_med'
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
          }
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
    'lambdalisue/fern.vim',
    dependencies = 'antoinemadec/FixCursorHold.nvim',
    cmd = 'Fern',
    init = function()
      vim.g['fern#disable_default_mappings'] = 1
      vim.g['fern#disable_viewer_spinner'] = 1
      vim.g["fern#default_hidden"] = 1
      vim.g['fern#default_hidden'] = 1
      vim.g['fern#drawer_width'] = 23
      vim.g['fern#default_exclude'] = '^\%(\.git\|\.DS_Store\)$'

      vim.keymap.set('n', '<Leader>nt', '<cmd><C-u>Fern . -drawer -toggle<cr>', { noremap = true, silent = true })
      vim.keymap.set('n', '<Leader>nf', '<cmd><C-u>Fern . -drawer -reveal=%<cr>', { noremap = true, silent = true })

      local function init_fern()
        vim.keymap.set('n', '<Plug>(fern-my-open-or-expand-or-collapse)', function() vim.fn['fern#smart#leaf']('<Plug>(fern-action-open)', '<Plug>(fern-action-expand)', '<Plug>(fern-action-collapse)') end, { buffer = true, expr = true })
        vim.keymap.set('n', 'o', '<Plug>(fern-my-open-or-expand-or-collapse)', { buffer = true })

        vim.keymap.set('n', 'T', '<Plug>(fern-action-open:tabedit)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'i', '<Plug>(fern-action-open:split)', { buffer = true, nowait = true })
        vim.keymap.set('n', 's', '<Plug>(fern-action-open:vsplit)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'a', '<Plug>(fern-action-new-path)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'm', '<Plug>(fern-action-move)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'c', '<Plug>(fern-action-copy)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'd', '<Plug>(fern-action-remove)', { buffer = true, nowait = true })

        vim.keymap.set('n', 'P', 'gg', { buffer = true, nowait = true })
        vim.keymap.set('n', 'p', '<Plug>(fern-action-focus:parent)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'K', '<Plug>(fern-action-focus:parent)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'C', '<Plug>(fern-action-enter)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'u', '<Plug>(fern-action-leave)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'r', '<Plug>(fern-action-reload)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'R', 'gg<Plug>(fern-action-reload)<C-o>', { buffer = true, nowait = true })

        vim.keymap.set('n', 'A', '<Plug>(fern-action-choice)', { buffer = true, nowait = true })
        vim.keymap.set('n', 'y', '<Plug>(fern-action-yank:path)', { buffer = true, nowait = true })

        vim.keymap.set('n', 'q', '<cmd><C-u>quit<cr>', { buffer = true, nowait = true })
      end

      vim.api.nvim_create_autocmd('VimEnter', {
        group = 'MyAutoCmd',
        nested = true,
        callback = function()
          if vim.fn.argc() == 0 then
            vim.cmd.Fern('. -drawer -reveal=%')
          end
        end,
      })
      vim.api.nvim_create_autocmd('FileType', {
        group = 'MyAutoCmd',
        pattern = 'fern',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          pcall(init_fern)
        end
      })
    end,
  },

  {
    'beauwilliams/focus.nvim',
    event = 'VeryLazy',
    config = function()
      require('focus').setup({ excluded_filetypes = { 'fern' } })
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
    init = function()
      vim.keymap.set('n', '<space>f', '<cmd>Telescope find_files<cr>', { noremap = true })
      vim.keymap.set('n', '<space>g', '<cmd>Telescope live_grep<cr>', { noremap = true })
      vim.keymap.set('n', '<space>b', '<cmd>Telescope buffers<cr>', { noremap = true })
    end,
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
          }
        }
      }
    end,
  },

  -- ------------------------------------
  --  Color
  -- ------------------------------------
  {
    'calorie/calorie.nvim',
    lazy = false,
    dependencies = 'rktjmp/lush.nvim',
    config = function()
      vim.opt.termguicolors = true
      vim.cmd([[colorscheme calorie]])
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    build = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { 'go', 'hcl', 'html', 'javascript', 'json', 'lua', 'markdown', 'ruby', 'rust', 'sql', 'vim', 'yaml' },
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
    keys = { '<Plug>(comment_toggle_linewise_current)', '<Plug>(comment_toggle_linewise_visual)' },
    init = function()
      vim.keymap.set('n', 'gcc', '<Plug>(comment_toggle_linewise_current)', { noremap = true, silent = true })
      vim.keymap.set('v', 'gc', '<Plug>(comment_toggle_linewise_visual)', { noremap = true, silent = true })
    end,
    config = function()
      require('Comment').setup {}
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },

  {
    'neovim/nvim-lspconfig',
    event = 'BufRead',
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
              "!And sequence",
              '!If',
              "!If sequence",
              '!Not',
              "!Not sequence",
              '!Equals',
              "!Equals sequence",
              '!Or',
              "!Or sequence",
              "!FindInMap",
              '!FindInMap sequence',
              '!Base64',
              '!Cidr',
              '!Ref',
              '!Ref Scalar',
              '!Sub',
              "!Sub sequence",
              '!GetAtt',
              '!GetAZs',
              '!ImportValue',
              "!ImportValue sequence",
              '!Select',
              "!Select sequence",
              '!Split',
              "!Split sequence",
              "!Join",
              '!Join sequence',
            },
          },
        },
      }
    end,
  },

  {
    'AndrewRadev/switch.vim',
    cmd = 'Switch',
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
      },

      vim.keymap.set('n', '+', '<cmd>Switch<cr>', { noremap = true, silent = true })
      vim.keymap.set('n', '-', function() vim.fn['switch#Switch']({ definitions = vim.g.variable_style_switch_definitions }) end, { noremap = true, silent = true })
    end,
  },

  {
    'godlygeek/tabular',
    cmd = { 'Tabularize', 'AddTabularPipeline' },
    init = function()
      vim.keymap.set('v', 'tb', '<cmd>Tabularize /', { noremap = true })
    end,
  },

  {
    'brglng/vim-im-select',
    event = 'InsertEnter',
    config = function()
      vim.g.im_select_default = 'com.google.inputmethod.Japanese.Roman'
    end,
  },

  {
    'tpope/vim-surround',
    keys = {
      '<Plug>Dsurround', '<Plug>Dsurround',
      '<Plug>VgSurround', '<Plug>VSurround',
      '<Plug>Yssurround', '<Plug>YSsurround',
      '<Plug>Ysurround', '<Plug>YSurround',
    },
    init = function()
      vim.keymap.set('n', 'ds', '<Plug>Dsurround')
      vim.keymap.set('n', 'cs', '<Plug>Csurround')
      vim.keymap.set('x', 'S', '<Plug>VSurround')
      vim.keymap.set('x', 'gS', '<Plug>VgSurround')

      local char2nr = vim.fn.char2nr
      vim.g['surround_' .. char2nr('e')] = "begin \r end"
      vim.g['surround_' .. char2nr('d')] = "do \r end"
      vim.g['surround_' .. char2nr('-')] = ":\r"
    end,
  },

  {
    'gbprod/yanky.nvim',
    keys = {
      '<Plug>(YankyPutAfter)', '<Plug>(YankyPutBefore)',
      '<Plug>(YankyGPutAfter)', '<Plug>(YankyGPutBefore)',
      '<Plug>(YankyCycleForward)', '<Plug>(YankyCycleBackward)',
      '<Plug>(YankyYank)',
    },
    init = function()
      vim.keymap.set({'n', 'x'}, 'p', '<Plug>(YankyPutAfter)')
      vim.keymap.set({'n', 'x'}, 'P', '<Plug>(YankyPutBefore)')
      vim.keymap.set({'n', 'x'}, 'gp', '<Plug>(YankyGPutAfter)')
      vim.keymap.set({'n', 'x'}, 'gP', '<Plug>(YankyGPutBefore)')
      vim.keymap.set('n', '<c-p>', '<Plug>(YankyCycleForward)')
      vim.keymap.set('n', '<c-n>', '<Plug>(YankyCycleBackward)')
      vim.keymap.set({'n', 'x'}, 'y', '<Plug>(YankyYank)')
    end,
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
    keys = { '<Plug>(clever-f-f)', '<Plug>(clever-f-F)' },
    init = function()
      vim.keymap.set('n', 'f', '<Plug>(clever-f-f)', { noremap = true })
      vim.keymap.set('n', 'F', '<Plug>(clever-f-F)', { noremap = true })
    end,
  },

  {
    'phaazon/hop.nvim',
    cmd = {
      'HopWord', 'HopWordMW', 'HopLineStart',
      'HopLineStartMW', 'HopVertical', 'HopVerticalMW',
    },
    init = function()
      vim.keymap.set('n', '<Leader>j', '<cmd>HopVerticalAC<cr>', { noremap = true, silent = true })
      vim.keymap.set('n', '<Leader>k', '<cmd>HopVerticalBC<cr>', { noremap = true, silent = true })
      vim.keymap.set('n', '<Leader>h', '<cmd>HopWord<cr>', { noremap = true, silent = true })
      vim.keymap.set('n', '<Leader>l', '<cmd>HopWordMW<cr>', { noremap = true, silent = true })

      vim.api.nvim_create_autocmd('FileType', {
        group = 'MyAutoCmd',
        pattern = 'fern',
        callback = function()
          vim.keymap.set('n', 'J', '<cmd>HopVerticalAC<cr>', { noremap = true, silent = true })
          vim.keymap.set('n', 'K', '<cmd>HopVerticalBC<cr>', { noremap = true, silent = true })
        end
      })
    end,
  },
})
