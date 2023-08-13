local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>h", mark.add_file, {desc = "Harpoon add file"})
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, {desc = "Harpoon menu"})
vim.keymap.set("n", "<space>1", function() ui.nav_file(1) end, {desc = "Harpoon file: 1"})
vim.keymap.set("n", "<space>2", function() ui.nav_file(2) end, {desc = "Harpoon file: 2"})
vim.keymap.set("n", "<space>3", function() ui.nav_file(3) end, {desc = "Harpoon file: 3"})
vim.keymap.set("n", "<space>4", function() ui.nav_file(4) end, {desc = "Harpoon file: 4"})
