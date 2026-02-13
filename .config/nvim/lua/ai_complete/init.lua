local M = {}

-- Function to get the current buffer content
function M.get_buffer_content()
    return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

-- Placeholder for Tree-sitter check
function M.is_cursor_in_function()
    local bufnr = vim.api.nvim_get_current_buf()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    local filetype = vim.bo[bufnr].filetype
    local parser = vim.treesitter.get_parser(bufnr, filetype)
    if not parser then
        print("No Tree-sitter parser found for current buffer language.")
        return false
    end

    local tree = parser:parse()[1]
    if not tree then
        print("No Tree-sitter AST found.")
        return false
    end

    local node = vim.treesitter.get_node({ bufnr = bufnr, row = row - 1, col = col })

    while node do
        if node:type() == "function_definition" or node:type() == "local_function_definition" or
           (node:type() == "assignment" and node:named_child(0):type() == "variable_expression" and
            node:named_child(1):type() == "function_definition") then
            return true
        end
        node = node:parent()
    end
    return false
end

function M.complete_function()
    if not M.is_cursor_in_function() then
        print("Cursor is not inside a function. Aborting.")
        return
    end

    local file_content = M.get_buffer_content()
    local completed_snippet = M.call_llm(file_content)

    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, current_line, current_line, false, vim.split(completed_snippet, '\n'))
end

-- Placeholder for LLM call
function M.call_llm(file_content)
    -- TODO: Implement actual LLM API call here
    print("Calling LLM with content (not actually sent):")
    for _, line in ipairs(file_content) do
        print(line)
    end
    print("LLM call not yet implemented.")
    return "function_body_from_llm()" -- Placeholder return
end

-- Define Neovim command
vim.api.nvim_create_user_command('AICompleteFunction', M.complete_function, {
    desc = 'Complete the current function using AI',
    bang = true
})

return M