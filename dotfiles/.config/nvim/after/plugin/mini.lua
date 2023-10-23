require('mini.ai').setup()
require('mini.align').setup()
require('mini.bracketed').setup()
require('mini.comment').setup()



require('mini.files').setup()
local nmap = require('syde.keymap').nmap
nmap('<M-f>', '<cmd>lua MiniFiles.open()<CR>', "Mini [f]iles")

-- local indentscope = require('mini.indentscope')
-- indentscope.setup({
--   symbol = '▏',
--   draw = {
--     delay = 0,
--     animation = indentscope.gen_animation.none(),
--   },
-- })

require('mini.pairs').setup()
require('mini.starter').setup()
require('mini.surround').setup()




-- local miniclue = require('mini.clue')
-- miniclue.setup({
--   triggers = {
--     -- Leader triggers
--     { mode = 'n', keys = '<Leader>' },
--     { mode = 'x', keys = '<Leader>' },
--
--     -- Built-in completion
--     { mode = 'i', keys = '<C-x>' },
--
--     -- `g` key
--     { mode = 'n', keys = 'g' },
--     { mode = 'x', keys = 'g' },
--
--     -- Marks
--     { mode = 'n', keys = "'" },
--     { mode = 'n', keys = '`' },
--     { mode = 'x', keys = "'" },
--     { mode = 'x', keys = '`' },
--
--     -- Registers
--     { mode = 'n', keys = '"' },
--     { mode = 'x', keys = '"' },
--     { mode = 'i', keys = '<C-r>' },
--     { mode = 'c', keys = '<C-r>' },
--
--     -- Window commands
--     { mode = 'n', keys = '<C-w>' },
--
--     -- `z` key
--     { mode = 'n', keys = 'z' },
--     { mode = 'x', keys = 'z' },
--   },
--
--   clues = {
--     -- Enhance this by adding descriptions for <Leader> mapping groups
--     miniclue.gen_clues.builtin_completion(),
--     miniclue.gen_clues.g(),
--     miniclue.gen_clues.marks(),
--     miniclue.gen_clues.registers(),
--     miniclue.gen_clues.windows(),
--     miniclue.gen_clues.z(),
--   },
-- })
