vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/gbprod/yanky.nvim",
  "https://github.com/gbprod/substitute.nvim",
  "https://github.com/RRethy/vim-illuminate",
  { src = "https://github.com/catppuccin/nvim",                     name = "catppuccin" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim", name = "ibl" },
})

-- base

vim.cmd.colorscheme("catppuccin-macchiato")
vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "TabLineSel" })

vim.g.mapleader = ","

vim.keymap.set("n", "<leader>bn", "<cmd>enew<cr>")
vim.keymap.set("n", "<leader>pu", vim.pack.update)

-- lsp

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "gopls", "rust_analyzer", "sorbet", "ty", "ruff", "lua_ls" },
})

vim.lsp.config("sorbet", {
  cmd = { "env", "SRB_SKIP_GEM_RBIS=1", ".vscode/run-sorbet", "--lsp" }
})
vim.lsp.enable("sorbet")

vim.lsp.config("lua_ls", {
  on_init = function(client)
    client.config.settings.Lua.workspace = {
      library = vim.api.nvim_get_runtime_file("", true),
    }
  end,
})

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if not client:supports_method("textDocument/willSaveWaitUntil") and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

require("illuminate").configure()

-- diagnostics

vim.diagnostic.config({
  virtual_lines = true
})

vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist)

-- mini

require("mini.ai").setup()

require("mini.basics").setup({
  options = { basic = true, extra_ui = true },
  mappings = { basic = true, windows = true },
})

require("mini.bracketed").setup()

require("mini.bufremove").setup()
vim.keymap.set("n", "<leader>bd", function() MiniBufremove.delete() end)
vim.keymap.set("n", "<leader>bD", function() MiniBufremove.delete(0, true) end)

require("mini.completion").setup()

require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "┃", change = "┃", delete = "▁" },
  },
})

require("mini.files").setup({ options = { permanent_delete = false } })
vim.keymap.set("n", "<leader>o", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)

local indentscope = require("mini.indentscope")
indentscope.setup({
  draw = { animation = indentscope.gen_animation.none() },
  options = { try_as_border = true },
  symbol = "│",
})

require("mini.icons").setup()

require("mini.misc").setup_auto_root()

require("mini.move").setup()

require("mini.notify").setup()

require("mini.pick").setup()
require("mini.extra").setup()
vim.keymap.set("n", "<leader>ff", MiniPick.builtin.files)
vim.keymap.set("n", "<leader>fr", MiniExtra.pickers.oldfiles)
vim.keymap.set("n", "<leader>fg", MiniPick.builtin.grep_live)
vim.keymap.set("n", "<leader>fw", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end)
vim.keymap.set("n", "<leader>fb", MiniPick.builtin.buffers)
vim.keymap.set("n", "<leader>fs", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol_live" }) end)
vim.keymap.set("n", "<leader>fl", MiniPick.builtin.resume)

local starter = require("mini.starter")
starter.setup({
  evaluate_single = true,
  items = {
    starter.sections.builtin_actions(),
    starter.sections.recent_files(5, false),
    starter.sections.recent_files(5, true),
  },
})

require("mini.statusline").setup()

require("mini.surround").setup({
  mappings = { add = "ys", delete = "ds", replace = "cs" }
})

require("mini.trailspace").setup()

require("mini.tabline").setup()

-- yanky / substitute

require("yanky").setup()

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

local substitute = require("substitute")
substitute.setup({
  on_substitute = require("yanky.integration").substitute(),
})

vim.keymap.set("n", "s", substitute.operator, { noremap = true })
vim.keymap.set("n", "ss", substitute.line, { noremap = true })
vim.keymap.set("n", "S", substitute.eol, { noremap = true })
vim.keymap.set("x", "s", substitute.visual, { noremap = true })

-- indent-blankline

require("ibl").setup({
  indent = { char = "│" }
})
