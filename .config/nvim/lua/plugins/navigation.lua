return {
  {
    'rhysd/clever-f.vim',
    keys = {
      { 'f', '<Plug>(clever-f-f)', mode = 'n', noremap = true },
      { 'F', '<Plug>(clever-f-F)', mode = 'n', noremap = true },
    },
  },

  {
    'smoka7/hop.nvim',
    keys = {
      { '<leader>j', '<cmd>HopVerticalAC<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>k', '<cmd>HopVerticalBC<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>h', '<cmd>HopWord<cr>', mode = 'n', noremap = true, silent = true },
      { '<leader>l', '<cmd>HopWordMW<cr>', mode = 'n', noremap = true, silent = true },
    },
    opts = {},
  },

  {
    'nvim-mini/mini.files',
    event = 'VeryLazy',
    version = '*',
    init = function()
      local function open_with_deferred_preview(path, use_latest)
        local mini_files = require('mini.files')

        mini_files.open(path, use_latest, {
          windows = {
            preview = false,
          },
        })

        vim.schedule(function()
          if vim.v.exiting ~= vim.NIL then
            return
          end

          if mini_files.get_explorer_state() == nil then
            return
          end

          mini_files.refresh({
            windows = {
              preview = true,
            },
          })
        end)
      end

      vim.api.nvim_create_autocmd('UIEnter', {
        group = 'MyAutoCmd',
        once = true,
        callback = function(data)
          if vim.fn.filereadable(data.file) == 1 then
            return
          end

          vim.schedule(function()
            if vim.v.exiting ~= vim.NIL then
              return
            end

            open_with_deferred_preview()
          end)
        end,
      })

      vim.keymap.set('n', '<leader>f', function()
        open_with_deferred_preview()
      end, { noremap = true, silent = true })

      vim.keymap.set('n', '<leader>nf', function()
        local mini_files = require('mini.files')
        local _ = mini_files.close() or open_with_deferred_preview(vim.api.nvim_buf_get_name(0), false)
        mini_files.reveal_cwd()
      end, { noremap = true, silent = true })

      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          local cur_target = MiniFiles.get_explorer_state().target_window
          local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(direction .. ' split')
            return vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target)
          MiniFiles.go_in { close_on_file = true }
        end

        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. direction })
      end

      vim.api.nvim_create_autocmd('User', {
        group = 'MyAutoCmd',
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          map_split(buf_id, 's', 'horizontal')
          map_split(buf_id, 'l', 'vertical')
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        group = 'MyAutoCmd',
        pattern = 'MiniFilesWindowOpen',
        callback = function(args)
          local win_id = args.data.win_id

          vim.api.nvim_set_option_value('foldmethod', 'manual', { win = win_id })
          vim.api.nvim_set_option_value('foldenable', false, { win = win_id })

          vim.api.nvim_set_option_value('statuscolumn', '', { win = win_id })
          vim.api.nvim_set_option_value('signcolumn', 'no', { win = win_id })

          vim.api.nvim_set_option_value('winbar', '', { win = win_id })
        end,
      })
    end,
    opts = {
      content = {
        prefix = function() end,
        filter = function(fs_entry)
          return not (fs_entry.name == '.git' and fs_entry.fs_type == 'directory')
        end,
      },
      mappings = {
        go_in       = 'L',
        go_in_plus  = 'o',
        go_out      = 'H',
        go_out_plus = 'p',
      },
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 100,
      },
      options = {
        use_as_default_explorer = false,
      },
    },
  },

  {
    'vladdoster/remember.nvim',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    opts = {},
  },

  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      {
        'nvim-telescope/telescope-frecency.nvim',
        config = function()
          require('telescope').load_extension 'frecency'
        end,
      },
    },
    keys = {
      { '<space>f', '<cmd>Telescope find_files<cr>', mode = 'n', noremap = true },
      { '<space>g', '<cmd>Telescope live_grep<cr>', mode = 'n', noremap = true },
      { '<space>b', '<cmd>Telescope buffers<cr>', mode = 'n', noremap = true },
    },
    opts = {
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
          disable_devicons = true,
        }
      },
    },
  },
}
