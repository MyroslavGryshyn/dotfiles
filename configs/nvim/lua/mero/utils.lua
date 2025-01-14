OpenTree = false
function toggleTree()
    if OpenTree then
        vim.cmd("NvimTreeClose")
        OpenTree = false
    else
        vim.cmd("NvimTreeFindFile")
        OpenTree = true
    end
end

return {
    toggleTree = toggleTree
}
