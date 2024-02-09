vim.cmd('au BufNewFile,BufRead *.templ set filetype=templ')
-- vim.filetype.add({extensions = {gotempl = "go"}})


return {
    options = {
        opt = {
            shiftwidth = 4,
            tabstop = 4,
        },
    },
    colorscheme = "koalight"
}
