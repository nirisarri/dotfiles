-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true, silent = true })

--Opens the explorer snack if closed, if opened, refocus the cursor on the snack.
--If on the snack, it will close it.
vim.keymap.set("n", "<leader>e", function()
    -- Snacks.picker.get returns an array; get the first active explorer
    local explorer = Snacks.picker.get({ source = "explorer" })[1]
    if not explorer then
        -- If it's completely closed, open a new one
        Snacks.explorer()
    elseif not explorer:is_focused() then
        -- If it's open but you are in a code file, jump focus into it
        explorer:focus()
    else
        -- If you are already inside it, close it
        explorer:close()
    end
end, { desc = "Toggle or Focus Explorer" })
