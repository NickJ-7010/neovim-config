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
        },
        image = { enable = true },
        picker = {
            toggles = {
                hidden = false,
                ignored = false
            },
            sources = {
                files = {
                    hidden = true,
                    ignored =  true,
                    transform = function()
                        return item
                    end
                }
            },
            layout = {
                preset = "telescope"
            }
        },
    },
    treesitter = {
        indent = { enable = true },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false
        },
        folds = { enable = true },
        auto_install = true,
        ensure_installed = {
            "bash",
            "c",
            "css",
            "diff",
            "go",
            "help",
            "html",
            "java",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "latex",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "printf",
            "python",
            "query",
            "regex",
            "scss",
            "svelte",
            "toml",
            "tsx",
            "typescript",
            "typst",
            "vim",
            "vimdoc",
            "vue",
            "xml",
            "yaml"
        }
    },
    oil = {
        default_file_explorer = true,
        view_options = { show_hidden = true }
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
    theme = {
        transparent = true,
        styles = {
            sidebars = "transparent",
            floats = "transparent",
        }
    }
}

local keys = {
    trouble = {
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>cs",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>cl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>xL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>xQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },
    neotest = function()
        require("neotest").setup({
            adapters = {
                require("neotest-java")({
                    -- Optional configuration here
                }),
            },
        })
    end,
}

require("lazy").setup({
    { "folke/tokyonight.nvim", priority = 1000, opts = configs.theme },
    { "vyfor/cord.nvim", build = ':Cord update', lazy = false, opts = configs.cord },
    { "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate", opts = configs.treesitter },
    { "pmizio/typescript-tools.nvim", event = "BufEnter", dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" }, opts = {} },
    { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, opts = configs.lualine },
    { "folke/snacks.nvim", priority = 999, lazy = false, opts = configs.snacks },
    { 'arkav/lualine-lsp-progress', opts = {} },
    { 'nvim-mini/mini.pairs', version = '*', opts = {} },
    { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },
    { 'stevearc/oil.nvim', dependencies = { "nvim-tree/nvim-web-devicons" }, opts = configs.oil },
    { "saghen/blink.cmp", dependencies = { 'rafamadriz/friendly-snippets' }, version = '1.*', opts = configs.blink, opts_extend = { "sources.default" } },
    { "mason-org/mason.nvim", opts = {} },
    { "mason-org/mason-lspconfig.nvim", dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" }, opts = { } },
    { "folke/trouble.nvim", opts = {}, cmd = "Trouble", keys = keys.trouble },
    { "mrcjkb/rustaceanvim" },
    { "lervag/vimtex", lazy = false },
    { 'nvim-java/nvim-java', config = function() require('java').setup(); vim.lsp.enable('jdtls') end },
    { "rcasia/neotest-java", ft = "java" },
    { "nvim-neotest/neotest", dependencies = { "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" }, config = configs.neotest },
}, {
	ui = {
        border = "rounded"
    }
})

vim.g.vimtex_view_method = "skim"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
  aux_dir = '/tmp/vimtex_out',
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.cmd("VimtexCompile")
  end,
})

require("typescript-tools").setup({})

local JDK_HOME = "/Library/Java/JavaVirtualMachines/liberica-jdk-25-full.jdk/Contents/Home"

vim.env.JAVA_HOME = JDK_HOME
vim.env.PATH = JDK_HOME .. "/bin:" .. vim.env.PATH

require('java').setup({
    jdk = {
        auto_install = false
    }
})

vim.lsp.config('jdtls', {
    cmd_env = {
        JAVA_HOME = JDK_HOME,
        PATH = JDK_HOME .. "/bin:" .. vim.env.PATH
    },
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-25",
                        path = JDK_HOME,
                        default = true
                    }
                }
            },
            project = {
                sourcePaths = { "src" }
            }
        }
    }
})

vim.cmd.colorscheme "tokyonight-night"

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

vim.keymap.set("n", "cl", "<cmd>noh<CR>")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>bf", function () vim.lsp.buf.format() end)
vim.keymap.set("n", "<leader>qq", "<cmd>qa<CR>")

vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>")

vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end)

local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end)
vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end)
vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end)
vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end)
vim.keymap.set("n", "<leader>0", function() harpoon:list():select(10) end)

vim.keymap.set('n', '<leader>ff', Snacks.picker.files, { desc = 'Snacks picker find files' })
vim.keymap.set('n', '<leader>fg', Snacks.picker.grep, { desc = 'Snacks picker live grep' })
vim.keymap.set('n', '<leader>fb', Snacks.picker.buffers, { desc = 'Snacks picker buffers' })
vim.keymap.set('n', '<leader>fd', Snacks.picker.diagnostics, { desc = 'Snacks picker diagnostics' })

