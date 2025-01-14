vim.keymap.set("n", ",d", vim.cmd.Gdiff)
vim.keymap.set("n", ",b", ":Git blame<CR>")
vim.keymap.set("n", ",l", ":Glog<CR>")

vim.cmd("set diffopt+=vertical")

