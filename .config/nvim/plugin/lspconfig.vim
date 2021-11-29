hi default GHTextViewDark guifg=#ebdbb2 guibg=#282828
hi default GHListDark guifg=#ebdbb2 guibg=#282828
hi default GHListHl guifg=#ebdbb2 guibg=#282828

lua << EOF

require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "guihua" },
})

require('lsp_signature').setup()


require('navigator').setup({
    lsp = {
        servers = {'cmake'},
        format_on_save = false,
    },
    keymaps={
        {
            key = 'gd', func = "require('navigator.definition').definition()"
        },
        {
            key = 'ca', func = "require('navigator.codeAction').code_action()"
        },
        {
            key = 'rn', func = "require('navigator.rename').rename()"
        },
        {
            key = 'gn', func = "diagnostic.goto_next({ border = 'rounded', max_width = 80})"
        },
        {
            key = 'gp', func = "diagnostic.goto_prev({ border = 'rounded', max_width = 80})"
        },
        {
            key = 'gP', func = "require('navigator.definition').definition_preview()"
        },
        {
            key = "<leader>t", func = "require('navigator.symbols').document_symbols()"
        },
        {
            key = '<A-F>', func = "formatting()", mode = 'n'
        },
        {
            key = '<A-F>', func= "range_formatting()", mode = 'v'
        }
    },
})
EOF
