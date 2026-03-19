local map = vim.keymap.set

vim.g.mapleader = " "

map("i", "jj", "<Esc>", {})
map("n", "<leader>li", ":Lazy install<CR>", {})
map("n", "<leader>lu", ":Lazy update<CR>", {})

map("n", "-", ":nohl<CR>", {})
map("n", "W", ":w<CR>", {})
map("n", "Q", ":q<CR>", {})

-- Use ctrl-[hjkl] to select the active split!
map("n", "<c-k>", ":wincmd k<CR>")
map("n", "<c-j>", ":wincmd j<CR>")
map("n", "<c-h>", ":wincmd h<CR>")
map("n", "<c-l>", ":wincmd l<CR>")

map({"n", "v"}, "gy", [["+y]])
map({"n", "v"}, "gp", [["+P]])

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Coc
map("n", "<leader>hn", "<Cmd>CocCommand document.toggleInlayHint<CR>", {
  silent = true
})
-- Rename as in IDE
map("n", "<leader>rr", "<Plug>(coc-rename)")


map("n", "<leader>v", ":vsplit<CR>")

map("n", "X", ":q<CR>")
map("n", "QA", ":qa<CR>")

map("n", "<F9>", ":Black<CR>")

map("n", "<leader>n", function() require('mero.utils').toggleTree() end, { noremap = true, silent = true, desc = "Toggle file tree" })

map("n", "<C-g>", ":FzfLua files<CR>", { noremap = true, silent = true })
map("n", "<leader>gs", ":FzfLua git_status<CR>", { noremap = true, silent = true })
map("n", "<leader>L", ":FzfLua lines<CR>", { noremap = true, silent = true })
map("n", "<leader>l", ":FzfLua blines<CR>", { noremap = true, silent = true })
map("n", "<leader>b", ":FzfLua buffers<CR>", { noremap = true, silent = true })
map("n", "<leader>t", ":FzfLua tags_grep_visual<CR>", { noremap = true, silent = true })
map("n", "<leader>ag", ":FzfLua grep_visual<CR>", { noremap = true, silent = true })

-- Full path
map("n", "cp", ":let @+ = expand('%:p')<CR>")
-- Just filename
map("n", "cpf", ":let @+ = expand('%:t')<CR>")

-- Tabs
map("n", "<C-t>", ":tabnew<CR>")
map("n", "<C-p>", ":tabprevious<CR>")
map("n", "<C-n>", ":tabnext<CR>")

-- Flake8
map("n", "<F8>", ":Flake<CR>")

-- Open config dir
map("n", "<leader>ev", ":e ~/dotfiles/configs/nvim<CR>")

-- Harpoon
local harpoon = require("harpoon")
harpoon:setup()

map("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: add file" })
map("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: toggle menu" })


