return {
  -- {
  --   'yetone/avante.nvim',
  --   build = 'make',
  --   dependencies = {
  --     'folke/snacks.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --     'hrsh7th/nvim-cmp',
  --     'zbirenbaum/copilot.lua',
  --   },
  --   keys = {
  --     { '<leader>aa', '<cmd>AvanteAsk<CR>', desc = 'Ask Avante' },
  --     { '<leader>ac', '<cmd>AvanteChat<CR>', desc = 'Chat with Avante' },
  --     { '<leader>af', '<cmd>AvanteFocus<CR>', desc = 'Focus Avante' },
  --     { '<leader>as', '<cmd>AvanteStop<CR>', desc = 'Stop Avante' },
  --     { '<leader>at', '<cmd>AvanteToggle<CR>', desc = 'Toggle Avante' },
  --   },
  --   opts = {
  --     provider = 'gemini',
  --
  --     gemini = {
  --       model = 'gemini-2.5-pro',
  --       temperature = 0,
  --       max_tokens = 4096,
  --     },
  --
  --     selection = {
  --       hint_display = 'none',
  --     },
  --
  --     behaviour = {
  --       auto_suggestions = false,
  --       auto_set_keymaps = false,
  --     },
  --   },
  -- },

  {
    'zbirenbaum/copilot.lua',
    -- dependencies = 'copilotlsp-nvim/copilot-lsp',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      server = {
        type = 'binary',
      },
      server_opts_overrides = {
        settings = {
          telemetry = {
            telemetryLevel = 'off',
          },
        },
      },
      -- nes = {
      --   enabled = true,
      --   keymap = {
      --     accept_and_goto = '<leader>p',
      --     accept = false,
      --     dismiss = '<Esc>',
      --   },
      -- },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    cmd = 'Gitsigns',
    keys = {
      { '<leader>bl', '<cmd>Gitsigns blame<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>di', '<cmd>Gitsigns toggle_signs<cr>', mode = 'n', noremap = true, silent = true },
    },
    opts = {
      signcolumn = false,
      current_line_blame_formatter = '<abbrev_sha> <author>, <author_time:%Y-%m-%d> - <summary>',
    },
  },

  {
    'nvimdev/lspsaga.nvim',
    keys = {
      { '<leader>ca', '<cmd>Lspsaga code_action<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>ca', '<cmd><C-U>Lspsaga range_code_action<cr>', mode = 'v', noremap = true, silent = true },
      { 'K', '<cmd>Lspsaga peek_definition<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>o', '<cmd>Lspsaga outline<cr>', mode = 'n', noremap = true, silent = true },
      -- { 'gd', '<cmd>Lspsaga hover_doc<cr>', mode = 'n', noremap = true, silent = true },
    },
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = false,
      },
    },
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'sh -c "if command -v yarn >/dev/null 2>&1; then cd app && yarn install; fi"',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
  },

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
        version = 'v2.*',
        build = 'make install_jsregexp',
        dependencies = {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load {
              include = {
                'docker-compose',
                'docker_file',
                'gitcommit',
                'global',
                'go',
                'html',
                'javascript',
                'kubernetes',
                'lua',
                'make',
                'markdown',
                'plantuml',
                'ruby',
                'shell',
                'sql',
                'terraform',
                'typescript',
              }
            }
          end,
        },
      },
      'windwp/nvim-autopairs',
    },
    keys = {
      { '<tab>', function() require('luasnip').jump(1) end, mode = 's' },
      { '<s-tab>', function() require('luasnip').jump(-1) end, mode = { 'i', 's' } },
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

  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = 'hrsh7th/cmp-nvim-lsp',
    init = function()
      vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        group = 'MyAutoCmd',
        pattern = { '*.tf', '*.tfvars' },
        callback = function()
          vim.lsp.buf.format({ async = true })
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = 'MyAutoCmd',
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client.server_capabilities.inlayHintProvider then
             vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end

          local bufopts = { noremap = true, silent = true, buffer = ev.buf }
          vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', '<leader>i', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
          end, bufopts)
          -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        end,
      })
    end,
    config = function()
      vim.lsp.log.set_level(vim.log.levels.OFF)

      vim.diagnostic.config({
        virtual_text = true,
        signs = false,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      vim.lsp.config('gopls', {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
            ['ui.inlayhint.hints'] = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              parameterNames = true,
              rangeVariableType = true,
              functionTypeParameters = true,
            },
          },
        },
      })

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

      vim.lsp.config('solargraph', {
        init_options = { diagnostics = true },
      })

      vim.lsp.config('terraformls', {
        init_options = {
          ignoreSingleFileWarning = true
        }
      })

      vim.lsp.config('ts_ls', {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.jsx',
        },
        root_markers = { 'package.json', '.git', vim.uv.cwd() },
      })

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

      vim.lsp.enable({
        'gopls',
        'jsonls',
        'sqlls',
        'solargraph',
        'terraformls',
        'ts_ls',
        'yamlls',
      })
    end,
  },

  {
    'h3pei/trace-pr.nvim',
    cmd = { 'TracePR' },
    opts = {},
  },

  {
    'romus204/tree-sitter-manager.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'TSManager',
    opts = {
      ensure_installed = {
        'bash', 'go', 'hcl', 'json', 'lua', 'markdown', 'markdown_inline',
        'ruby', 'sql', 'terraform', 'typescript', 'yaml',
      },
      auto_install = false,
      highlight = true,
    },
  },

  {
    'andymass/vim-matchup',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    init = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      vim.g.matchup_matchparen_stopline = 400
      vim.g.matchup_treesitter_disabled = { 'markdown' }
    end,
  },

  {
    'thinca/vim-quickrun',
    keys = {
      { '<leader>r', '<cmd>QuickRun<cr>', mode = 'n', noremap = true, silent = true },
    },
  },
}
