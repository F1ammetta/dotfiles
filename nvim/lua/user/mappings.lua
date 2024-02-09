return {
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"

    -- harpoon mappings
    -- set leader h to open harpoon menu
    ["<leader>h"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Harpoon Menu" },
    -- alt ; to tag file
    ["<A-;>"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Harpoon Add File" },

    -- alt j and k to cycle 
    ["<CA-j>"] = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = "Harpoon Nav Next" },
    ["<CA-k>"] = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = "Harpoon Nav Prev" },

    -- alt l to nav file
    ["<A-l>1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "Harpoon Nav File 1" },
    ["<A-l>2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "Harpoon Nav File 2" },
    ["<A-l>3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "Harpoon Nav File 3" },
    ["<A-l>4"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "Harpoon Nav File 4" },
    ["<A-l>5"] = { "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", desc = "Harpoon Nav File 5" },
    ["<A-l>6"] = { "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", desc = "Harpoon Nav File 6" },
    ["<A-l>7"] = { "<cmd>lua require('harpoon.ui').nav_file(7)<cr>", desc = "Harpoon Nav File 7" },
    ["<A-l>8"] = { "<cmd>lua require('harpoon.ui').nav_file(8)<cr>", desc = "Harpoon Nav File 8" },
    ["<A-l>9"] = { "<cmd>lua require('harpoon.ui').nav_file(9)<cr>", desc = "Harpoon Nav File 9" },
    ["<A-l>0"] = { "<cmd>lua require('harpoon.ui').nav_file(10)<cr>", desc = "Harpoon Nav File 10" },



    -- ["<leader>li"] = { "<cmd>VimtexCompile<cr>", desc = "Vimtex Compile"},
    -- ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    -- ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
    -- ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
    -- ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
