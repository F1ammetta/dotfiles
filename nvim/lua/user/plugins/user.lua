return {
        {
            "goolord/alpha-nvim",
            opts = function(_, opts)
                opts.section.header.val = {
                    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀",
                    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣷⣤⣀⠀⠀⠀⠀⠀⠉⠑⣶⣤⣄⣀⣠⣤⣶⣶⣿⣿⣿⣿⡇⠀⠀⠀",
                    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀⠀⠀⣀⠤⠒⠉⠈⢉⡉⠻⢿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀",
                    "⠀⠀⠀⠀⣀⣴⣶⣿⣷⡄⠀⠀⠀⠀⢹⣿⣿⣿⣿⠏⠁⠀⢀⠄⠀⠀⠈⢀⠄⠀⢀⡖⠁⠀⢀⠀⠈⠻⣿⣿⣿⣿⡏⠀⠀⠀⠀",
                    "⠀⠀⢠⣾⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⢸⣿⣿⠏⠀⠀⢀⡴⠁⠀⠀⣠⠖⠁⢀⠞⠋⠀⢠⡇⢸⡄⠀⠀⠈⢻⣿⣿⠁⠀⠀⠀⠀",
                    "⠀⣠⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⢸⡿⠁⠀⠀⢀⡞⠀⠀⢀⡴⠃⠀⣰⠋⠀⠀⣰⡿⠀⡜⢳⡀⠘⣦⠀⢿⡇⠀⠀⠀⠀⠀",
                    "⢠⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⢰⣿⠃⠀⢀⠆⡞⡄⠀⣠⡞⠁⣀⢾⠃⠀⣀⡜⢱⠇⣰⠁⠈⣷⠂⢸⡇⠸⣵⠀⠀⠀⠀⠀",
                    "⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⢠⣿⠇⠀⠀⡜⣸⡟⢀⣴⡏⢠⣾⠋⡎⢀⣼⠋⢀⡎⡰⠃⠀⠀⣿⣓⢒⡇⠀⣿⠀⠀⠀⠀⠀",
                    "⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠴⢻⣟⢀⣀⢀⣧⡇⢨⠟⢾⣔⡿⠃⢸⢀⠞⠃⢀⣾⡜⠁⠀⠀⠀⡏⠁⢠⠃⠀⢹⠀⠀⠀⠀⠀",
                    "⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⢸⣼⢸⣿⡟⢻⣿⠿⣶⣿⣿⣿⣶⣾⣏⣀⣠⣾⣿⠔⠒⠉⠉⢠⠁⡆⡸⠀⡈⣸⠀⠀⠀⠀⠀",
                    "⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⣸⣿⣸⣿⣇⢸⠃⡄⢻⠃⣾⣿⢋⠘⣿⣿⠏⣿⡟⣛⡛⢻⣿⢿⣶⣷⣿⣶⢃⣿⠀⠀⠀⠀⠀",
                    "⢸⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⣰⠃⣿⣿⣿⣿⠀⣸⣧⠈⣸⣿⠃⠘⠃⢹⣿⠀⣿⠃⠛⠛⣿⡇⢸⣿⡇⢸⣿⡿⣿⡀⠀⠀⠀⠀",
                    "⠀⠻⣿⣿⣿⣿⣦⡀⠀⢀⡔⣹⣼⡟⡟⣿⣿⣿⠛⠻⠶⠿⠷⣾⣿⣿⣬⣿⣠⣿⣀⣿⣿⣿⡇⠸⡿⠀⣾⡏⢠⣿⣇⠀⠀⠀⠀",
                    "⠀⠀⠙⢿⣿⣿⣿⣿⣷⡞⢠⣿⢿⡇⣿⡹⡝⢿⡷⣄⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠙⠛⠛⠻⠿⣶⣶⣾⣿⣇⣾⠉⢯⠃⠀⠀⠀",
                    "⠀⠀⠀⠀⠙⠿⣿⣿⣿⠇⢸⠇⠘⣇⠸⡇⣿⣮⣳⡀⠉⠂⠀⠀⣀⣤⡤⢤⣀⠀⠀⠀⠀⠀⢈⣿⠟⣠⣾⠿⣿⡆⡄⣧⡀⠀⠀",
                    "⠀⠀⠀⠀⠀⠀⠀⠙⠻⡘⠾⣄⠀⠘⢦⣿⠃⠹⣿⣿⣶⠤⠀⠀⣿⠋⠉⠻⣿⠁⠀⠠⣀⣤⣾⣵⣾⡿⠃⣾⠏⣿⣧⠋⡇⠀⠀",
                    "⠀⠀⠀⠀⠀⠀⠀⣠⠖⠳⣄⡈⠃⠀⠼⠋⠙⢷⣞⢻⣿⣿⣀⡀⠈⠤⣀⠬⠟⠀⢀⣠⣶⠿⢛⡽⠋⣠⣾⣏⣠⡿⣃⣞⠀⠀⠀",
                    "⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠉⠛⠓⠢⠶⣶⡤⠺⡟⢺⣿⠿⣿⣶⣤⣀⣠⣴⣾⡿⠿⢵⠋⠙⠲⣏⡝⠁⠀⣹⢿⡣⣌⠒⠄⠀",
                    "⠀⠀⠀⠀⠀⠀⢸⠈⡄⠀⠇⠀⠀⡖⠁⢢⡞⠀⢰⠻⣆⡏⣇⠙⠻⣿⣿⣿⣿⠋⢀⡴⣪⢷⡀⠀⡘⠀⢀⠜⠁⢀⠟⢆⠑⢄⠀",
                    "⠀⠀⠀⠀⠀⠀⠘⡄⠱⠀⠸⡀⠄⠳⡀⠀⢳⡀⢰⠀⢸⢇⡟⠑⠦⢈⡉⠁⢼⢠⡏⣴⠟⢙⠇⠀⡇⢠⠃⢀⡴⠁⠀⠘⠀⠈⡆",
                    "⠀⠀⠀⠀⠀⠀⠀⠇⠀⠣⠀⡗⢣⡀⠘⢄⠀⢧⠀⢳⡟⠛⠙⣧⣧⣠⣄⣀⣠⢿⣶⠁⠀⠸⡀⠀⠓⠚⢴⣋⣠⠔⠀⠀⠀⠀⠁",
                    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠧⡤⠙⢤⡈⣦⡼⠀⠀⠧⢶⠚⡇⠈⠁⠈⠃⠀⡰⢿⣄⠀⠀⠑⢤⣀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀",
                }
                local button, get_icon = require("astronvim.utils").alpha_button, require("astronvim.utils").get_icon
                opts.section.buttons.val = {
                    button("LDR n  ", get_icon("FileNew", 2, true) .. "New File  "),
                    button("LDR f f", get_icon("Search", 2, true) .. "Find File  "),
                    button("LDR f w", get_icon("WordFile", 2, true) .. "Find Word  "),
                }
                opts.config.layout = {
                    { type = "padding", val = 1 },
                    opts.section.header,
                    { type = "padding", val = 1 },
                    opts.section.buttons,
                    { type = "padding", val = 3 },
                    opts.section.footer,
                }
            end,

        },

        {"rcarriga/nvim-notify",
            opts = function(_, opts)
                opts.background_colour = "#000000"
            end,
        },

        {
            "github/copilot.vim",
            event = "UIEnter"
        },

        {
            "theprimeagen/harpoon",
            event = "UIEnter"
        },

        {
            'koalhack/koalight.nvim',
            priority = 1000
        },

        {
            "rebelot/heirline.nvim",
            opts = function(_, opts)
                opts.tabline = nil -- remove tabline
                return opts
            end,
        },

        {
            "rcarriga/nvim-notify",
            enabled = false,
        },

        {
            "xiyaowong/transparent.nvim",
            event = "UIEnter",
            priority = 1000,
        },
}
