return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",
    config = function ()
      local mason_registry = require('mason-registry')
      local codelldb = mason_registry.get_package("codelldb")
      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path.. "lldb/lib/liblldb.dylib"
	-- If you are on Linux, replace the line above with the line below:
	-- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      local cfg = require('rustaceanvim.config')

      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end
  },
  {
    'rust-lang/rust.vim',
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
			local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
		end,
  },

  {
    'rcarriga/nvim-dap-ui', 
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
			require("dapui").setup()
		end,
  },

  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true
          },
        },
      }
      require('cmp').setup.buffer({
        sources = { { name = "crates" }}
      })
    end
  },
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
      }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-context",
    },
    build = function()
        local ts_update = require("nvim-treesitter.install").update {
            with_sync = true,
        }
        ts_update()
    end,
    config = function()
        local ts_config = require "nvim-treesitter.configs"
        require("treesitter-context").setup {
            max_lines = 1,
        }

        ts_config.setup {
            ensure_installed = {
                -- languages
                "bash",
                "c",
                "clojure",
                "fennel",
                "go",
                "gomod",
                "gosum",
                "groovy",
                "java",
                "javascript",
                "kotlin",
                "lua",
                "python",
                "rust",
                "scheme",
                "sql",
                "tsx",
                "vim",
                "vimdoc",
                -- markup
                "css",
                "html",
                "markdown",
                "markdown_inline",
                "mermaid",
                "xml",
                "asm",
                -- config
                "dot",
                "toml",
                "yaml",
                -- data
                "csv",
                "json",
                "json5",
                -- utility
                "diff",
                "ssh_config",
                "printf",
                "disassembly",
                "dockerfile",
                "git_config",
                "git_rebase",
                "gitcommit",
                "gitignore",
                "http",
                "query",
            },
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(
                        vim.loop.fs_stat,
                        vim.api.nvim_buf_get_name(buf)
                    )
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["a="] = {
                            query = "@assignment.outer",
                            desc = "Select outer part of an assignment",
                        },
                        ["i="] = {
                            query = "@assignment.inner",
                            desc = "Select inner part of an assignment",
                        },
                        ["r="] = {
                            query = "@assignment.rhs",
                            desc = "Select right hand side of an assignment",
                        },

                        ["aa"] = {
                            query = "@parameter.outer",
                            desc = "Select outer part of a parameter/argument",
                        },
                        ["ia"] = {
                            query = "@parameter.inner",
                            desc = "Select inner part of a parameter/argument",
                        },

                        ["ai"] = {
                            query = "@conditional.outer",
                            desc = "Select outer part of a conditional",
                        },
                        ["ii"] = {
                            query = "@conditional.inner",
                            desc = "Select inner part of a conditional",
                        },

                        ["al"] = {
                            query = "@loop.outer",
                            desc = "Select outer part of a loop",
                        },
                        ["il"] = {
                            query = "@loop.inner",
                            desc = "Select inner part of a loop",
                        },

                        ["am"] = {
                            query = "@call.outer",
                            desc = "Select outer part of a function call",
                        },
                        ["im"] = {
                            query = "@call.inner",
                            desc = "Select inner part of a function call",
                        },

                        ["af"] = {
                            query = "@function.outer",
                            desc = "Select outer part of a method/function definition",
                        },
                        ["if"] = {
                            query = "@function.inner",
                            desc = "Select inner part of a method/function definition",
                        },

                        ["ac"] = {
                            query = "@class.outer",
                            desc = "Select outer part of a class",
                        },
                        ["ic"] = {
                            query = "@class.inner",
                            desc = "Select inner part of a class",
                        },

                        ["an"] = {
                            query = "@block.outer",
                            desc = "Select inner part of a block",
                        },
                        ["in"] = {
                            query = "@block.inner",
                            desc = "Select outer part of a block",
                        },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]i"] = "@conditional.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]I"] = "@conditional.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[i"] = "@conditional.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[I"] = "@conditional.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>man"] = "@parameter.inner",
                        ["<leader>mfn"] = "@function.outer",
                        ["<leader>mcn"] = "@class.outer",
                    },
                    swap_previous = {
                        ["<leader>map"] = "@parameter.inner",
                        ["<leader>mfp"] = "@function.outer",
                        ["<leader>mcp"] = "@class.outer",
                    },
                },
            },
        }

        vim.keymap.set("n", "[c", function()
            require("treesitter-context").go_to_context(vim.v.count1)
        end, { silent = true })
        local parser_config =
            require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.tsx.filetype_to_parsername =
            { "javascript", "typescript.tsx" }
    end,
  },
  {
    "nvim-treesitter/playground",
    lazy = true,
    cmd = {
        "TSPlaygroundToggle",
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
        {"nvim-lua/plenary.nvim"},
        {"nvim-telescope/telescope.nvim"},
    },
    event = "LspAttach",
    config = function()
        require('tiny-code-action').setup()
    end
  },
}
