local telescope = vim.F.npcall(require, "telescope")
local nmap = require('syde.keymap').nmap
if telescope then
  -- Clone the default Telescope configuration
  local vimgrep_arguments = require("telescope.config").values.vimgrep_arguments

  -- I want to search in hidden/dot files.
  table.insert(vimgrep_arguments, "--hidden")
  -- I don't want to search in the `.git` directory.
  table.insert(vimgrep_arguments, "--glob")
  table.insert(vimgrep_arguments, "!**/.git/*")

  telescope.setup {
    pickers = {
      find_files = {
        -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
      },
    },
    defaults = {
      -- `hidden = true` is not supported in text grep commands.
      vimgrep_arguments = vimgrep_arguments,
      file_ignore_patterns = {
        "__pycache__",
        "target",
        "node_modules",
        "undodir",
      },
      prompt_prefix = " ",
      layout_config = {
        prompt_position = 'top',
        horizontal = {
          height = 0.9,
          width = 0.9,
        },
      },
      sorting_strategy = 'ascending',
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      },
      undo = {
        use_delta = true,
      },
    }
  }

  telescope.load_extension('fzf')
  telescope.load_extension("git_worktree")
  telescope.load_extension("undo")


  local builtin = require('telescope.builtin')
  nmap("<leader>?", builtin.keymaps, "Search keymaps")
  nmap("<leader>b", builtin.buffers, "[b]uffers")
  nmap("<leader>fc", builtin.current_buffer_fuzzy_find, "[f]uzzy [c]urrent buffer search")
  nmap("<leader>ff", builtin.find_files, "[f]ind [f]iles")
  nmap("<leader>F", builtin.git_files, "Git [F]iles")
  nmap("<leader>fh", builtin.help_tags, "[f]uzzy search [h]elp tags")
  nmap("<leader>fg", builtin.live_grep, "[f]ile search with [g]rep")
  nmap("<leader>/", builtin.live_grep, "Global search with grep")
  -- nmap("gr", builtin.lsp_references, "Goto References")
  -- nmap("gi", builtin.lsp_implementations, "Goto [i]mplementations")
  -- nmap("gl", builtin.lsp_implementations, "Goto [i]mplementations")

  nmap("<leader>gw", "<cmd>Telescope git_worktree git_worktrees<CR>", "[g]it [w]orktrees")
  nmap("<leader>u", "<cmd>Telescope undo<CR>", "[u]ndos")
else
  local MiniPick = vim.F.npcall(require, 'mini.pick')
  if MiniPick then
    MiniPick.setup {

    }
    MiniPick.registry.buffer_lines = function(local_opts)
      -- Parse options
      local_opts = vim.tbl_deep_extend('force', { buf_id = nil, prompt = '' }, local_opts or {})
      local buf_id, prompt = local_opts.buf_id, local_opts.prompt
      local_opts.buf_id, local_opts.prompt = nil, nil

      -- Construct items
      if buf_id == nil or buf_id == 0 then buf_id = vim.api.nvim_get_current_buf() end
      local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
      local items = {}
      for i, l in ipairs(lines) do
        items[i] = { text = string.format('%d:%s', i, l), bufnr = buf_id, lnum = i }
      end

      -- Start picker while scheduling setting the query
      vim.schedule(function() MiniPick.set_picker_query(vim.split(prompt, '')) end)
      MiniPick.start({ source = { items = items, name = 'Buffer lines' } })
    end


    nmap("<leader>ff", MiniPick.builtin.files, "Pick [f]iles")
    nmap("<leader>c", MiniPick.registry.buffer_lines, "Pick [c]urrent buffer lines")
    nmap("<leader>fg", MiniPick.builtin.grep_live, "Pick [g]rep")
    nmap("<leader>/", MiniPick.builtin.grep_live, "Global search with grep")
    nmap("<leader>fh", MiniPick.builtin.help, "Pick [h]elp")
    nmap("<leader>b", MiniPick.builtin.buffers, "Pick [b]uffers")
  end
end
