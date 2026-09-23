return {
    "folke/snacks.nvim",
    opts = function()
        return {
            picker = {
                hidden = true,
                ignored = true,
                sources = {
                    explorer = {
                        hidden = true,
                        ignored = true,
                    },
                },
            },
        }
    end,
}
