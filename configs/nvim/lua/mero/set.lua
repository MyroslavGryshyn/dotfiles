vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "88"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.completeopt = "longest,menuone"
vim.opt.shell = "/bin/zsh"

vim.opt.splitright = true

-- Folding with treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false  -- Start with folds open
vim.opt.foldlevel = 99      -- High fold level so folds are open by default

vim.g.python_host_prog="/Users/myroslavhryshyn/.virtualenvs/neovim/bin/python"

