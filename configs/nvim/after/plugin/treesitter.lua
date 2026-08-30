-- nvim-treesitter `main` branch API: no more `nvim-treesitter.configs`
-- module/setup() call. Parsers are installed explicitly, and highlight/
-- fold/indent are wired up per-buffer via core vim.treesitter.* APIs.
-- See https://github.com/nvim-treesitter/nvim-treesitter (main branch README).

local ensure_installed = {
  "bash", "c", "css", "html", "javascript", "json", "lua",
  "markdown", "markdown_inline", "python", "query", "toml",
  "tsx", "typescript", "vim", "vimdoc", "yaml",
}

require("nvim-treesitter").install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    -- Disable slow treesitter highlight for large files, same threshold
    -- the old `highlight.disable` function used.
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then
      return
    end

    -- Errors if there's no installed parser for this filetype; just skip
    -- highlight/indent setup for those buffers. (Folding is handled
    -- globally in lua/mero/set.lua via the same core foldexpr, which
    -- degrades gracefully without a parser.)
    local started = pcall(vim.treesitter.start)
    if not started then
      return
    end

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
