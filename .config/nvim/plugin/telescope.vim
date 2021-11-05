nnoremap <C-p> <cmd>lua require'telescope-config'.project_files()<cr>
nnoremap <C-b> <cmd>Telescope file_browser<cr>
nnoremap <C-f> <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>f <cmd>Telescope live_grep<cr>
nnoremap <space>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>

lua << EOF
local previewers = require('telescope.previewers')

local new_maker = function(filepath, bufnr, opts)
    opts = opts or {}

    local threshold = 100000
    filepath = vim.fn.expand(filepath)
    vim.loop.fs_stat(filepath, function(_, stat)
      if not stat then return end
      if stat.size > threshold then
        return
      else
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      end
    end)
end

require('telescope').setup({
    extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                           -- the default case_mode is "smart_case"
        }
    },
    defaults = require('telescope.themes').get_dropdown {
     preview = {
       timeout = 500,
       buffer_previewer_maker = new_maker,
     },
     vimgrep_arguments = {
       "rg",
       "--color=never",
       "--no-heading",
       "--with-filename",
       "--line-number",
       "--column",
       "--smart-case",
       "--hidden",
     },
    },
})


require('telescope').load_extension('fzf')
EOF
