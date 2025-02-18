local nmap = Keymap.nmap
local nxmap = Keymap.map({ 'x', 'n' })

Load.now(function()
    local greeting = function()
        local hour = tonumber(vim.fn.strftime('%H'))
        -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
        local part_id = math.floor((hour + 4) / 8) + 1
        local day_part = ({ 'evening', 'morning', 'afternoon', 'evening' })[part_id]
        local username = vim.uv.os_get_passwd()['username'] or 'USERNAME'

        return ('Good %s, %s'):format(day_part, username)
    end

    require('mini.starter').setup({
        header = function()
            local banner = [[

    /\__\         /\  \         /\  \         /\__\          ___        /\__\
   /::|  |       /::\  \       /::\  \       /:/  /         /\  \      /::|  |
  /:|:|  |      /:/\:\  \     /:/\:\  \     /:/  /          \:\  \    /:|:|  |
 /:/|:|  |__   /::\~\:\  \   /:/  \:\  \   /:/__/  ___      /::\__\  /:/|:|__|__
/:/ |:| /\__\ /:/\:\ \:\__\ /:/__/ \:\__\  |:|  | /\__\  __/:/\/__/ /:/ |::::\__\
\/__|:|/:/  / \:\~\:\ \/__/ \:\  \ /:/  /  |:|  |/:/  / /\/:/  /    \/__/~~/:/  /
    |:/:/  /   \:\ \:\__\    \:\  /:/  /   |:|__/:/  /  \::/__/           /:/  /
    |::/  /     \:\ \/__/     \:\/:/  /     \::::/__/    \:\__\          /:/  /
    /:/  /       \:\__\        \::/  /       ~~~~         \/__/         /:/  /
    \/__/         \/__/         \/__/                                   \/__/

]]
            local msg = greeting()
            local n = math.floor((70 - msg:len()) / 2)
            local padding = (' '):rep(n)
            return banner .. padding .. msg
        end,
    })
end)

Load.now(function() require('mini.sessions').setup() end)

Load.later(function()
    local gen_loader = require('mini.snippets').gen_loader
    require('mini.snippets').setup({
        snippets = {
            gen_loader.from_file('~/.config/nvim/snippets/global.json'),
            gen_loader.from_lang(),
        },
        mappings = {
            expand = '<C-h>',
            jump_next = '<C-i>',
            jump_prev = '<C-e>',
            stop = '<C-c>',
        },
    })
end)

Load.later(function()
    require('mini.icons').setup()
    Load.now(MiniIcons.tweak_lsp_kind)
    MiniIcons.mock_nvim_web_devicons()
end)

Load.now(function()
    require('mini.files').setup({
        mappings = {
            close = 'q',
            go_in = 'i',
            go_in_plus = 'I',
            go_out = 'm',
            go_out_plus = 'M',
            mark_goto = "'",
            mark_set = 'h',
            reset = '<BS>',
            reveal_cwd = '@',
            show_help = 'g?',
            synchronize = '=',
            trim_left = '<',
            trim_right = '>',
        },
    })
    nmap('<M-f>', function() MiniFiles.open() end, 'Show [f]ile-tree')
    nmap('<M-F>', function()
        local file_name = vim.api.nvim_buf_get_name(0)
        if vim.uv.fs_stat(file_name) then
            MiniFiles.open(file_name)
        else
            vim.notify('Current buffer is not a file... opening mini.files in CWD', vim.log.levels.INFO)
            MiniFiles.open()
        end
    end, 'Show current [F]ile in explorer')
end)

Load.later(function()
    require('mini.basics').setup({
        options = {
            basic = false,
        },
        mappings = {
            basic = true,
            option_toggle_prefix = [[]],
        },
        autocommands = {
            -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
            basic = true,
            relnum_in_visual_mode = false,
        },
    })
end)

Load.later(function() require('mini.tabline').setup() end)

Load.later(function() require('mini.extra').setup() end)

Load.later(function()
    Load.packadd('nvim-treesitter-textobjects')
    local spec_treesitter = require('mini.ai').gen_spec.treesitter
    local gen_ai_spec = MiniExtra.gen_ai_spec
    require('mini.ai').setup({
        n_lines = 500,
        custom_textobjects = {
            B = gen_ai_spec.buffer(),
            D = gen_ai_spec.diagnostic(),
            I = gen_ai_spec.indent(),
            L = gen_ai_spec.line(),
            N = gen_ai_spec.number(),
            F = spec_treesitter({
                a = '@function.outer',
                i = '@function.inner',
            }),
            o = spec_treesitter({
                a = { '@loop.outer' },
                i = { '@loop.inner' },
            }),
            c = spec_treesitter({
                a = { '@conditional.outer' },
                i = { '@conditional.inner' },
            }),
            v = spec_treesitter({
                a = { '@variable.outer' },
                i = { '@variable.inner' },
            }),
        },
    })
end)

Load.later(function() require('mini.align').setup() end)

Load.later(function()
    require('mini.bracketed').setup({ n_lines = 500 })
    nmap('U', '<C-r><Cmd>lua MiniBracketed.register_undo_state()<CR>', 'Redo')
end)

Load.later(function()
    local MiniBufremove = require('mini.bufremove')
    MiniBufremove.setup()
    nmap('<leader>mbd', function() MiniBufremove.delete() end, 'Delete current buffer')
end)

Load.later(function() require('mini.comment').setup() end)

Load.later(
    function()
        require('mini.operators').setup({
            replace = {
                prefix = 'cr',
            },
        })
    end
)

Load.later(function()
    require('mini.surround').setup({
        search_method = 'cover_or_next',
    })
end)

Load.later(function() require('mini.cursorword').setup({ delay = 100 }) end)

Load.later(function()
    local hipatterns = require('mini.hipatterns')
    -- local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
        highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            -- fixme     = hi_words({ 'FIX', 'FIXME' }, 'MiniHipatternsFixme'),
            -- note      = hi_words({ 'NOTE' }, 'MiniHipatternsNote'),
            -- hack      = hi_words({ 'HACK' }, 'MiniHipatternsHack'),
            -- todo      = hi_words({ 'TODO' }, 'MiniHipatternsTodo'),

            -- Highlight hex color strings (`#9436FF`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end)

Load.later(function() require('mini.jump').setup() end)

Load.later(function()
    local MiniJump2d = require('mini.jump2d')
    MiniJump2d.setup({
        spotter = MiniJump2d.gen_pattern_spotter('[^%s%p]+'),
        view = {
            -- Whether to dim lines with at least one jump spot
            dim = true,

            -- How many steps ahead to show. Set to big number to show all steps.
            n_steps_ahead = 2,
        },
    })
end)

Load.later(function() require('mini.splitjoin').setup() end)

Load.later(function()
    local MiniMove = require('mini.move')
    MiniMove.setup({
        mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = '<M-m>',
            right = '<M-i>',
            down = '<M-n>',
            up = '<M-e>',

            -- Move current line in Normal mode
            line_left = '<M-m>',
            line_right = '<M-i>',
            line_down = '<M-n>',
            line_up = '<M-e>',
        },

        -- Options which control moving behavior
        options = {
            -- Automatically reindent selection during linewise vertical move
            reindent_linewise = true,
        },
    })
end)

Load.later(function()
    require('mini.diff').setup({
        mappings = {
            -- Apply hunks inside a visual/operator region
            apply = '<leader>ga',

            -- Reset hunks inside a visual/operator region
            reset = '<leader>gr',

            -- Hunk range textobject to be used inside operator
            -- Works also in Visual mode if mapping differs from apply and reset
            textobject = 'gh',

            -- Go to hunk range in corresponding direction
            goto_first = '[H',
            goto_prev = '[h',
            goto_next = ']h',
            goto_last = ']H',
        },
    })
end)

Load.later(function()
    require('mini.git').setup()
    nxmap('<leader>gg', MiniGit.show_at_cursor, 'Show git info at cursor')
end)

Load.later(function()
    local MiniVisits = require('mini.visits')
    MiniVisits.setup()
    local make_select_path = function(select_global, recency_weight)
        return function()
            local cwd = select_global and '' or vim.fn.getcwd()
            local sort = MiniVisits.gen_sort.default({ recency_weight = recency_weight })
            local select_opts = { sort = sort }
            MiniVisits.select_path(cwd, select_opts)
            -- MiniExtra.pickers.visit_paths({
            --     cwd = cwd,
            --     -- sort = sort,
            --     recency_weight = recency_weight,
            -- })
        end
    end

    local visit_map = function(lhs, desc, ...) Keymap.nmap(lhs, make_select_path(...), desc) end

    -- Adjust LHS and description to your liking
    visit_map('<Leader>vr', 'Select recent (all)', true, 1)
    visit_map('<Leader>vR', 'Select recent (cwd)', false, 1)
    visit_map('<Leader>vy', 'Select frecent (all)', true, 0.5)
    visit_map('<Leader>vY', 'Select frecent (cwd)', false, 0.5)
    visit_map('<Leader>vf', 'Select frequent (all)', true, 0)
    visit_map('<Leader>vF', 'Select frequent (cwd)', false, 0)
end)

Load.later(function()
    require('mini.misc').setup()
    MiniMisc.setup_auto_root({ '.git', 'flake.nix', 'Makefile', 'Justfile' })
    MiniMisc.setup_termbg_sync()
end)

Load.later(function()
    require('mini.trailspace').setup()
    nmap('<M-t>', function()
        MiniTrailspace.trim()
        MiniTrailspace.trim_last_lines()
    end, 'Clean [t]railing whitespace')
end)

Load.later(function()
    local MiniStatusline = require('mini.statusline')
    local section_macro_recording = function()
        local recording_register = vim.fn.reg_recording()

        if recording_register == '' then
            return ''
        else
            return ('rec @%s'):format(recording_register)
        end
    end

    local diagnostic_level = function(level)
        local n = #vim.diagnostic.get(0, { severity = level })
        local sign = vim.diagnostic.config().signs.text[level]
        return (n == 0) and '' or ('%s %s'):format(sign, n)
    end

    local section_fileinfo = function(args)
        local get_filesize = function()
            local size = vim.fn.getfsize(vim.fn.getreg('%'))
            if size < 1024 then
                return ('%dB'):format(size)
            elseif size < 1048576 then
                return ('%.2fKiB'):format(size / 1024)
            else
                return ('%.2fMiB'):format(size / 1048576)
            end
        end

        local get_filetype_icon = function()
            if not MiniStatusline.config.use_icons then return '' end
            local MiniIcons = Load.now(require, 'mini.icons')
            local file_name = vim.fn.expand('%:t')
            local icon, _, is_default = MiniIcons.get('file', file_name)
            if is_default then return '' end

            return icon
        end
        local filetype = vim.bo.filetype

        -- Don't show anything if can't detect file type or not inside a "normal buffer"
        if (filetype == '') or vim.bo.buftype ~= '' then return '' end

        -- Add filetype icon
        local icon = get_filetype_icon()
        if icon ~= '' then filetype = ('%s %s'):format(icon, filetype) end

        -- Construct output string if truncated
        if MiniStatusline.is_truncated(args.trunc_width) then return filetype end

        -- Construct output string with extra file info
        local encoding = vim.bo.fileencoding or vim.bo.encoding
        if encoding == 'utf-8' then
            encoding = ''
        else
            encoding = ('[%s]'):format(encoding)
        end

        local format = vim.bo.fileformat
        local format_icon = ''
        if format == 'unix' then
            format_icon = ''
        elseif format == 'dos' then
            format_icon = ''
        end

        local size = get_filesize()

        return ('%s %s%s %s'):format(filetype, format_icon, encoding, size)
    end

    MiniStatusline.setup({
        content = {
            active = function()
                local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                local git = MiniStatusline.section_git({ trunc_width = 75 })
                local diff = MiniStatusline.section_diff({ trunc_width = 75 })
                local errors = diagnostic_level(vim.diagnostic.severity.ERROR) -- alternative symbol "⬤ "
                local warnings = diagnostic_level(vim.diagnostic.severity.WARN) -- alternative symbol ""
                local info = diagnostic_level(vim.diagnostic.severity.INFO)
                local hints = diagnostic_level(vim.diagnostic.severity.HINT)
                local macro = section_macro_recording()
                local filename = MiniStatusline.section_filename({ trunc_width = 140 })
                local searchcount = MiniStatusline.section_searchcount({ trunc_width = 75 })
                local fileinfo = section_fileinfo({ trunc_width = 120 })
                local location = MiniStatusline.section_location({ trunc_width = 75 })
                -- local lsp           = MiniStatusline.section_lsp({ trunc_width = 60 })

                return MiniStatusline.combine_groups({
                    { hl = mode_hl, strings = { mode } },
                    { hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
                    '%<', -- Mark general truncate point
                    { hl = 'MiniStatuslineFilename', strings = { filename } },
                    { hl = 'DiagnosticError', strings = { errors } },
                    { hl = 'DiagnosticWarn', strings = { warnings } },
                    { hl = 'DiagnosticHint', strings = { hints } },
                    { hl = 'DiagnosticInfo', strings = { info } },
                    '%=', -- End left alignment
                    --
                    { hl = 'MiniStatuslineFilename', strings = { macro, searchcount } },
                    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                    { hl = mode_hl, strings = { location } },
                })
            end,
        },
        set_vim_settings = false,
    })
end)
