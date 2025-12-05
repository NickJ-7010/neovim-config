local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local config_dir = vim.fn.stdpath('config')
vim.fn.system({
    "git",
    "-C",
    config_dir,
    "pull"
})

local configs = {
    cord = {
        editor = {
            tooltip = "Neovim"
        },
        display = {
            theme = "atom",
            flavor = "accent"
        }
    },
    snacks = {
        dashboard = { enabled = true },
        indent = {
            enabled = true,
            char = "│",
            only_scope = false, -- only show indent guides of the scope
            only_current = false, -- only show indent guides in the current window
        }
    },
    treesitter = {
        indent = { enable = true },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false
        },
        folds = { enable = true },
        ensure_installed = {
            "bash",
            "c",
            "diff",
            "go",
            "help",
            "html",
            "java",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "printf",
            "python",
            "query",
            "regex",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "xml",
            "yaml"
        }
    },
    oil = {
        default_file_explorer = false
    },
    blink = {
        keymap = { preset = 'super-tab' },
        appearance = {
            nerd_font_variant = 'mono'
        },
        completion = {
            documentation = {
                auto_show = true,
                window = { border = "rounded" }
            },
            menu = { border = "rounded" }
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    lualine = {
        sections = {
		    lualine_c = {
			    'lsp_progress'
		    }
	    }
    },
    catppuccin = {
        transparent_background = true,
        float = {
            transparent = true,
            solid = true
        },
    },
}

require("lazy").setup({
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, opts = configs.catppuccin },
    { "vyfor/cord.nvim", build = ':Cord update', lazy = false, opts = configs.cord },
    { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate", opts = configs.treesitter },
    { "pmizio/typescript-tools.nvim", event = "BufEnter", dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" }, opts = {} },
    { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, opts = configs.lualine },
    { "folke/snacks.nvim", priority = 999, lazy = false, opts = configs.snacks },
    { 'arkav/lualine-lsp-progress', opts = {} },
    { 'nvim-mini/mini.pairs', version = '*', opts = {} },
    { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },
    { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },
    { 'stevearc/oil.nvim', dependencies = { "nvim-tree/nvim-web-devicons" }, opts = configs.oil },
    { "saghen/blink.cmp", dependencies = { 'rafamadriz/friendly-snippets' }, version = '1.*', opts = configs.blink, opts_extend = { "sources.default" } },
    { "mason-org/mason.nvim", opts = {} },
    { "mason-org/mason-lspconfig.nvim", dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" }, opts = {} },
}, {
	ui = {
        border = "rounded"
    }
})

require("typescript-tools").setup({})

vim.cmd.colorscheme "catppuccin"

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"

vim.keymap.set("n", "cl", ":noh<CR>")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>o", ":Oil<CR>")

vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end)

local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fd', telescope.diagnostics, { desc = 'Telescope diagnostics' })

