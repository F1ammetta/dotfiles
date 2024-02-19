vim.cmd('au BufNewFile,BufRead *.templ set filetype=templ')
-- vim.filetype.add({extensions = {gotempl = "go"}})

local notify = vim.notify
vim.notify = function(msg, ...)
    if msg:match("warning: multiple different client offset_encodings") then
        return
    end

    notify(msg, ...)
end

return {
    options = {
        opt = {
            shiftwidth = 4,
            tabstop = 4,
        },
    },
    colorscheme = "koalight"
}
