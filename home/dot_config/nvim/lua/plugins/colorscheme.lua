return {
    {
        "cesaralvarod/tokyogogh.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyogogh").setup({
                style = "night", --caan be storm or night
                transparent = false,
            })
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyogogh",
        },
    },
}

-- return {
--     {
--         "folke/tokyonight.nvim",
--         lazy = false,
--         priority = 1000,
--         opts = {
--             style = "night",
--             transparent = false,
--         },
--     },
--     {
--         "LazyVim/LazyVim",
--         opts = {
--             colorscheme = "tokyonight",
--         },
--     },
-- }
