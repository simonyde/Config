Load.later(function()
    require('blink.cmp').setup({
        keymap = { preset = 'default' },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',
        },
        signature = { enabled = true },
        fuzzy = {
            prebuilt_binaries = {
                force_version = "",
            },
        },
        completion = {
            ghost_text = {
                enabled = false,
            },
        },
        sources = {
            default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
            },
        },
    })
end)
