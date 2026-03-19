vim.keymap.set("n", "<leader>gd", vim.cmd.Gdiff, { desc = "Git diff" })
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>gl", ":Glog<CR>", { desc = "Git log" })

vim.cmd("set diffopt+=vertical")
