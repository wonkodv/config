-- vim:foldmethod=marker:

-- Plugins {{{

-- Plug {{{
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('wonkodv/zem')
Plug('junegunn/vim-easy-align')
Plug('neovim/nvim-lsp')
Plug('neovim/nvim-lspconfig')
Plug('rust-lang/rust.vim')
Plug('ishan9299/nvim-solarized-lua')
Plug('tpope/vim-fugitive')
Plug('kaarmu/typst.vim')
vim.call('plug#end')
-- }}}

-- Interpreters {{{
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    vim.g.python3_host_prog = 'c:/Windows/py.exe'
end

vim.g.no_plugin_maps = 1 -- no key mappings from file types

vim.g.loaded_perl_provider = 1
vim.g.loaded_node_provider = 1
vim.g.loaded_ruby_provider = 1
vim.g.loaded_python_provider = 1
-- }}}

-- ZEM {{{
vim.g.zem_db = '.index'
vim.g.zem_height = 30
vim.g.zem_sources = {
    { 'files', {} },
    { 'tags',  { file = "!ctags --c-kinds=+px --python-kinds=-i -o - --recurse --sort=no --exclude=target" } }
}
-- }}}

-- }}} Plugins

-- {{{ FileTypes, Syntax

vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

vim.g.tex_flavor = "latex"
vim.g.markdown_folding = 1

local augroup = vim.api.nvim_create_augroup('myautocommands', { clear = true })

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = augroup,
    pattern = '*.tags',
    command = 'setlocal filetype=tags'
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = augroup,
    pattern = '.tags.*',
    command = 'setlocal filetype=tags'
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = augroup,
    pattern = '*.lds',
    command = 'setlocal filetype=ld'
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = augroup,
    pattern = '*.md',
    command = 'setlocal filetype=markdown'
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = augroup,
    pattern = '*.icf',
    command = 'setlocal filetype=iarlinker'
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = augroup,
    pattern = '*.mk',
    command = 'setlocal filetype=make'
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = augroup,
    pattern = '*/.git/*',
    command = 'setlocal bufhidden=wipe'
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = { 'gitcommit', 'gitrebase', 'gitconfig' },
    command = 'setlocal bufhidden=delete'
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = augroup,
    pattern = '*',
    callback = function()
        vim.cmd('setlocal cmdheight=2')
        QFSigns()
    end
})

vim.api.nvim_create_autocmd('TermOpen', {
    group = augroup,
    pattern = '*',
    callback = function()
        vim.opt_local.statusline = 'TERM:' .. vim.b.term_title
        vim.opt_local.spell = false
        vim.opt_local.number = true
    end
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = 'qf',
    command = 'setlocal wrap'
})

vim.api.nvim_create_autocmd('BufWritePost', {
    group = augroup,
    pattern = '*',
    callback = function()
        AutoChmod(vim.fn.expand('<afile>'))
    end
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup,
    pattern = '*',
    command = 'lcd .' -- update window title relative paths
})

-- vim.api.nvim_create_autocmd('BufReadPost', {
--     group = augroup,
--     pattern = '*',
--     callback = function()
--         JumpToLastEdit()
--     end
-- })

-- }}}

-- Colors, Highlighting {{{
vim.opt.background = 'light'
vim.opt.termguicolors = true
vim.g.solarized_visibility = 'normal'
vim.g.solarized_italics = 0

vim.cmd('colorscheme solarized')

vim.cmd('highlight clear SpellBad')
vim.cmd('highlight clear SpellCap')
vim.cmd('highlight clear SpellRare')
vim.cmd('highlight clear SpellLocal')
vim.cmd('highlight link markdownError NONE')

vim.cmd('highlight MatchParen gui=bold guifg=red')
vim.cmd('highlight Match guibg=#c4c4c4 guifg=#000066')

vim.cmd('highlight link LspReferenceText Match')
vim.cmd('highlight link LspReferenceRead Match')
vim.cmd('highlight link LspReferenceWrite Match')
-- }}}

-- Settings {{{

vim.opt.backupdir:remove('.')

vim.opt.backspace = { 'eol', 'indent', 'start' }
vim.opt.backup = true
vim.opt.breakindent = true
vim.opt.cedit = '<C-F>'
vim.opt.cinkeys = '0{,0},0),0],!^F,o,O'
vim.opt.cinoptions = 'L0,l1,b1,t0,(0,#1'
vim.opt.clipboard = 'unnamedplus'
vim.opt.complete = '.,w,b,u,t'
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.opt.completefunc = 'ZemComplete'
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.diffopt = 'filler,internal,context:4,algorithm:minimal,hiddenoff,indent-heuristic,linematch:60'
vim.opt.display = { 'lastline', 'uhex' }
vim.opt.expandtab = true
vim.opt.exrc = true
vim.opt.fileformats = { 'unix', 'dos' }
vim.opt.fixendofline = true
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'indent' -- syntax can be really expensive on large files
vim.opt.foldopen = { 'insert', 'jump', 'mark', 'percent', 'quickfix', 'search', 'tag', 'undo' }
vim.opt.formatoptions = 'rqn1j2'

if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = 'rg --vimgrep'
    vim.opt.grepformat = '%f:%l:%c:%m'
end

vim.opt.hidden = true
vim.opt.history = 100
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.indentkeys = '0{,0},0),0],!^F,o,O'
vim.opt.langmenu = 'en'
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '~', precedes = '<', extends = '>', nbsp = '+' }
vim.opt.linebreak = true
vim.opt.makeprg = 'make -rR'
vim.opt.matchpairs = { '(:)', '{:}', '[:]', '<:>' }
vim.opt.modeline = true
vim.opt.mouse = 'a'
vim.opt.wrap = false
vim.opt.nrformats = { 'alpha', 'hex', 'unsigned' }
vim.opt.number = true
vim.opt.path = { '**', '.', '' }
vim.opt.previewheight = 4
-- vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.scrollback = 100000
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3
vim.opt.signcolumn = 'number'
vim.opt.shellpipe = '2>&1|tee'
vim.opt.shell = '/var/run/current-system/sw/bin/bash'
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.shortmess = 'atIT'
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.showbreak = '\\'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.spell = true
vim.opt.spelllang = 'en'
-- vim.opt.statusline = '%<%f%=%(\ [%M%R%H%W%q]%)\ [%Y,%{&enc},%{&ff}]\ %6(%c%V,%l%)%(\ %P%)\ '
vim.opt.tabpagemax = 20
vim.opt.tabstop = 4
vim.opt.tags = '.tags'
vim.opt.textwidth = 80
vim.opt.timeout = false
vim.opt.timeoutlen = 2000
vim.opt.title = true
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 1000
vim.opt.updatetime = 300
vim.opt.viminfo = "'200,<50,s10,h,rA:,rB:,h,"
vim.opt.virtualedit = 'all'
vim.opt.wildignore = '**__pycache__**,result/'
vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest:full', 'full' }
vim.opt.winheight = 15
vim.opt.winminheight = 7
vim.opt.wrapscan = true

-- }}}

-- Functions {{{

-- MAKE {{{
function Make(bang, cmdOrTargets)
    -- Write current buffer if edited,
    -- execute make or other program in terminal in previewwindow
    -- go to Preview Window, scroll to End, install callback when Done
    -- Go back to currently edited File

    local cmd
    if bang == '!' then
        cmd = cmdOrTargets
    else
        cmd = vim.o.makeprg .. ' ' .. cmdOrTargets
    end
    cmd = '(' .. vim.fn.expandcmd(cmd) .. ' ; exit ${PIPESTATUS[0]} ; ) 2>&1 |tee .makelog ; exit ${PIPESTATUS[0]} ;'
    vim.g.Make_last_Command = cmd
    vim.cmd('wall')
    vim.cmd('wincmd z')
    vim.cmd('cclose')
    vim.cmd('silent botright pedit! +setlocal\\ buftype=nofile\\ nobuflisted\\ noswapfile\\ nolist\\ nohlsearch MAKE')
    vim.cmd('wincmd P')
    local buf = vim.fn.bufnr('%')
    vim.fn.termopen(cmd, {
        on_exit = function(job_id, return_code, event)
            vim.cmd('wincmd z')
            vim.cmd('cgetfile .makelog')
            QFSigns()
            vim.cmd('botright copen')

            if return_code == 0 then
                print("✅ Make Successful")
                vim.cmd('normal! G')
            else
                print("🟥 Make Failed " .. return_code)
                vim.cmd('cc')
            end

            vim.cmd('wincmd w')
            vim.cmd(buf .. 'bwipe!')
        end,
        buf = buf,
    })
    vim.cmd('normal! G')
    vim.cmd('wincmd p')
end

-- }}}

-- Navigate {{{
-- Better <C-X><C-F> Filename Completion.
-- Complete Files relative to each directory, from current file to CWD
-- Using an increasing set of characters

local FILE_REs = {
    vim.regex([[[a-z0-9_./\\]*$]]),
    vim.regex([[[a-z0-9_./\\ ]+$]]),
    vim.regex([[[a-z0-9_./\\ =]+$]]),
    vim.regex([[[a-z0-9_./\\ ='"]+$]]),
    vim.regex([[.+$]]),
}

function find_file_like(line)
    -- Find File-like substrings with increasing character set
    local result = {}
    local seen = {}
    for _, r in ipairs(FILE_REs) do
        local start_pos = r:match_str(line)
        if start_pos then
            local match = line:sub(start_pos + 1)
            if not seen[match] then
                table.insert(result, match)
                seen[match] = true
            end
        end
    end
    return result
end

function glob_relative(relative_file, prefix)
    -- Find Files in relative_file's parents
    local pattern = prefix .. "*"
    local result = {}
    local file = vim.fn.fnamemodify(relative_file, ':p')
    local parent = vim.fn.fnamemodify(file, ':h')
    local last_parent = ""

    while parent ~= last_parent do
        local matches = vim.fn.glob(parent .. '/' .. pattern, false, true)
        local r = {}
        for _, p in ipairs(matches) do
            local s = vim.fn.fnamemodify(p, ':t')
            if vim.fn.isdirectory(p) == 1 then
                s = s .. "/"
            end
            table.insert(r, s)
        end
        table.sort(r)
        for _, item in ipairs(r) do
            table.insert(result, item)
        end
        last_parent = parent
        parent = vim.fn.fnamemodify(parent, ':h')
    end
    return result
end

function find_suggestions(relative_file, prefixes)
    local suggestions = {}
    for _, prefix in ipairs(prefixes) do
        local matches = glob_relative(relative_file, prefix)
        if #matches > 0 then
            table.insert(suggestions, { prefix, matches })
        end
    end
    return suggestions
end

function complete_file(relative_file, line)
    local prefixes = find_file_like(line)
    local prefix_and_matches = find_suggestions(relative_file, prefixes)

    -- Sort by longest prefix first
    table.sort(prefix_and_matches, function(a, b) return #a[1] > #b[1] end)

    if #prefix_and_matches == 0 then
        return { #line, {} }
    end

    local longest_prefix = #prefix_and_matches[1][1]
    local start_column = #line - longest_prefix

    local results = {}
    for _, pm in ipairs(prefix_and_matches) do
        local prefix = pm[1]
        local matches = pm[2]
        for _, m in ipairs(matches) do
            local completion = line:sub(start_column + 1, - #prefix) .. m
            table.insert(results, completion)
        end
    end
    return { start_column, results }
end

function CompleteFile()
    local file = vim.fn.expand("%")
    local line_no = vim.fn.line(".")
    local col_no = vim.fn.col(".")
    local line = vim.fn.getline(line_no):sub(1, col_no)
    local completions = complete_file(file, line)
    vim.fn.complete(completions[1], completions[2])
    return ""
end

function JumpToLastEdit()
    if vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.bo.filetype) then
        return
    end
    if vim.tbl_contains({ 'help', 'nofile', 'quickfix' }, vim.bo.buftype) then
        return
    end
    if vim.wo.diff then
        return
    end
    local ok, _ = pcall(function()
        vim.cmd('keepjumps normal! g`"zv')
    end)
end

function FindBuildFile(bang)
    if bang ~= '!' then
        return FindInParent(vim.fn.expand("%"), "Makefile")
    end
    return "Makefile"
end

function FindInParent(start, file)
    local p = vim.fn.fnamemodify(start, ':p')
    while true do
        local f = vim.fn.fnamemodify(p .. '/' .. file, ':p')
        if vim.fn.filereadable(f) == 1 then
            return f
        end
        local parent = vim.fn.fnamemodify(p, ':h')
        if parent == p then
            break
        end
        p = parent
    end
    return ""
end

function GetFilenameAndLine()
    local line_no = vim.fn.line(".")
    local file_name = vim.fn.expand("%")
    local text = vim.fn.getline(line_no)
    return file_name .. "\nLine " .. line_no .. ":\n" .. text
end

function AllZemMatches(term)
    local list = {}
    local matches = ZemGetMatches(term, 20)
    for _, m in ipairs(matches) do
        local e
        if m.location:sub(1, 1) == "/" then
            e = {
                filename = m.file,
                pattern = m.location:sub(2, -2),
                text = m.name,
                valid = 1
            }
        else
            e = {
                filename = m.file,
                lnum = m.location,
                text = m.name,
                valid = 1
            }
        end
        table.insert(list, e)
    end
    vim.fn.setqflist({}, ' ', { title = term, items = list, nr = '$' })
end

-- }}}

-- Useful {{{

vim.cmd('sign define Check text=!> linehl=')
vim.cmd('sign define HL text=OK linehl=')

function QFSigns()
    vim.cmd('sign unplace *')
    local i = 1
    for _, d in ipairs(vim.fn.getqflist()) do
        if d.bufnr ~= 0 and d.lnum ~= 0 then
            vim.cmd(string.format(':sign place %d line=%d name=Check buffer=%d', i, d.lnum, d.bufnr))
            i = i + 1
        end
    end
end

-- sudo write
function SudoWrite()
    vim.cmd('w ! sudo dd of="%"')
    vim.cmd('e!')
    vim.cmd('redraw')
end

function TextObjComment(inner)
    -- /*aaa*/   x
    local l = vim.fn.getline('.')
    local p = vim.fn.getpos('.')[2]

    if l:sub(p - 1, p) == '/*' then
        vim.cmd('normal! l')
    elseif l:sub(p, p + 1) == '/*' then
        vim.cmd('normal! ll')
    elseif l:sub(p + 1, p + 2) == '/*' then
        vim.cmd('normal! lll')
    elseif l:sub(p - 1, p) == '*/' then
        vim.cmd('normal! h')
    elseif l:sub(p - 2, p - 1) == '*/' then
        vim.cmd('normal! hh')
    end

    if inner then
        vim.cmd('normal! [/llv]/hh')
    else
        vim.cmd('normal! [/v]/')
    end
end

function EditSibling(bang, ...)
    local args = { ... }
    local s = "tabedit  %:p"
    for i = 1, #args, 2 do
        local rep = args[i]
        local with = args[i + 1]
        if bang == "!" then
            s = s .. ":gs#\\<" .. rep .. "\\>#" .. with .. "#"
        else
            s = s .. ":gs#" .. rep .. "#" .. with .. "#"
        end
    end
    vim.cmd(s)
end

function DiffSibling(bang, ...)
    local args = { ... }
    local s = "vert diffsplit %:p"
    for i = 1, #args, 2 do
        local rep = args[i]
        local with = args[i + 1]
        if bang == "!" then
            s = s .. ":gs#\\<" .. rep .. "\\>#" .. with .. "#"
        else
            s = s .. ":gs#" .. rep .. "#" .. with .. "#"
        end
    end
    vim.cmd(s)
end

function MatchAdd(s)
    if not vim.g.MatchPattern or vim.g.MatchPattern == "" then
        vim.g.MatchPattern = s
    else
        vim.g.MatchPattern = vim.g.MatchPattern .. '\\|' .. s
    end

    vim.cmd('highlight Match guibg=#c4c4c4 guifg=#000066')
    vim.cmd('match Match /' .. vim.g.MatchPattern .. '/')
end

function ClearMatches()
    vim.g.MatchPattern = ''
    vim.cmd('match')
end

function ClearHighlights()
    vim.lsp.buf.clear_references()
end

function AutoChmod(fn)
    local ok, lines = pcall(vim.api.nvim_buf_get_lines, vim.fn.bufnr(fn), 0, 1, false)
    if ok and lines and lines[1] and lines[1]:sub(1, 2) == "#!" then
        vim.fn.system({ "chmod", "+x", fn })
    end
end

-- }}}

-- Character toggle {{{
local CHAR_PAIRS = {
    ["'"] = '"',
    ['"'] = "'",
    ['('] = "[",
    ['['] = "{",
    ['{'] = "(",
    [')'] = "]",
    [']'] = "}",
    ['}'] = ")",
    ['>'] = "<",
    ['<'] = ">",
    ['\\'] = "/",
    ['/'] = "\\",
    ['|'] = "&",
    ['&'] = "|",
    ['+'] = "-",
    ['-'] = "+",
}

function toggle_char()
    local w = vim.api.nvim_get_current_win()
    local b = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(w)
    local row = cursor[1]
    local col = cursor[2]
    local l = vim.api.nvim_buf_get_lines(b, row - 1, row, false)[1]
    local c = l:sub(col + 1, col + 1)
    local nc = CHAR_PAIRS[c] or c
    print(c .. " => " .. nc)
    local nl = l:sub(1, col) .. nc .. l:sub(col + 2)
    vim.api.nvim_buf_set_lines(b, row - 1, row, false, { nl })
end

-- }}}

function TerminalOpen()
    local terminals = vim.fn.getbufinfo({ bufloaded = 1 })
    local term_bufs = {}
    for _, buf in ipairs(terminals) do
        if buf.name:match("term://") then
            table.insert(term_bufs, buf.bufnr)
        end
    end
    if #term_bufs > 0 then
        local maxbuf = math.max(unpack(term_bufs))
        vim.cmd(':b ' .. maxbuf)
    else
        vim.cmd(':terminal')
    end
end

-- }}} Functions

-- Commands {{{

vim.api.nvim_create_user_command('Abort', function()
    vim.fn.rpcnotify(vim.b.nvr[1], 'Exit', 1)
end, {})

vim.api.nvim_create_user_command('DS', function(opts)
    DiffSibling(opts.bang and '!' or '', unpack(opts.fargs))
end, { bang = true, nargs = '+' })

vim.api.nvim_create_user_command('ES', function(opts)
    EditSibling(opts.bang and '!' or '', unpack(opts.fargs))
end, { bang = true, nargs = '+' })

vim.api.nvim_create_user_command('Make', function(opts)
    Make(opts.bang and '!' or '', opts.args)
end, { bang = true, nargs = '*', complete = 'file' })

vim.api.nvim_create_user_command('RM', function()
    vim.cmd('!rm -f %')
end, {})

vim.api.nvim_create_user_command('Rename', function(opts)
    vim.b._old_f = vim.fn.expand("%")
    vim.cmd('file ' .. opts.args)
    vim.fn.system("mkdir -p " .. vim.fn.expand("%:h"))
    vim.cmd('w')
    vim.cmd('e')
    vim.fn.system("rm -f " .. vim.b._old_f)
end, { nargs = 1, complete = 'file' })

vim.api.nvim_create_user_command('Suw', function()
    SudoWrite()
end, {})

vim.api.nvim_create_user_command('DefaultFile', function(opts)
    if vim.fn.argc() == 0 and vim.fn.bufnr() == 1 then
        vim.cmd('find ' .. opts.args)
    end
end, { nargs = 1 })

vim.api.nvim_create_user_command('Write', function()
    vim.cmd('w ++p')
end, {})

vim.api.nvim_create_user_command('Build', function()
    vim.cmd('Make')
end, {})

vim.api.nvim_create_user_command('Test', function()
    vim.cmd('Make test')
end, {})

vim.api.nvim_create_user_command('Check', function()
    vim.cmd('Make check')
end, {})

vim.api.nvim_create_user_command('Terminal', function()
    TerminalOpen()
end, {})

vim.api.nvim_create_user_command('TERMINAL', function()
    TerminalOpen()
end, {})

vim.api.nvim_create_user_command('T', function()
    TerminalOpen()
end, {})

function LspCommands()
    vim.api.nvim_buf_create_user_command(0, 'LspAction', function() vim.lsp.buf.code_action() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspCallsInc', function() vim.lsp.buf.incoming_calls() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspCallsOut', function() vim.lsp.buf.incoming_calls() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspClearReferences', function() vim.lsp.buf.clear_references() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspDeclaration', function() vim.lsp.buf.declaration() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspDefinition', function() vim.lsp.buf.definition() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspDocumentHighlight', function() vim.lsp.buf.document_highlight() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspFormatting', function() vim.lsp.buf.formatting() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspHover', function() vim.lsp.buf.hover() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspImplementation', function() vim.lsp.buf.implementation() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspListDocumentSymbols',
        function(opts) vim.lsp.buf.document_symbol(opts.args) end, { nargs = '?' })
    vim.api.nvim_buf_create_user_command(0, 'LspListWorkspaceSymbols',
        function(opts) vim.lsp.buf.workspace_symbol(opts.args) end, { nargs = '?' })
    vim.api.nvim_buf_create_user_command(0, 'LspNextDiagnostic', function() vim.diagnostic.jump({count=1,float=true}) end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspPrevDiagnostic', function() vim.diagnostic.jump({count=-1,float=true}) end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspQfList', function() vim.diagnostic.setqflist() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspReferences', function() vim.lsp.buf.references() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspRename', function() vim.lsp.buf.rename() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspSymbol', function() vim.lsp.buf.workspace_symbol() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspSignatureHelp', function() vim.lsp.buf.signature_help() end, {})
    vim.api.nvim_buf_create_user_command(0, 'LspTypeDefinition', function() vim.lsp.buf.type_definition() end, {})
end

-- }}}

-- Mappings {{{

local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(mode, lhs, rhs, opts)
end

map('n', '<leader>#', ':s/\\s*\\/\\*[^*]*\\*\\///<CR>:nohlsearch<CR>')
map('n', '<leader>;', ':s/;.*//<CR>:nohlsearch<CR>')
map('n', '<leader>,', '<C-^>')
map('n', '-', function() toggle_char() end)
map('v', '<leader>/',
    ':<C-U>let old_reg=getreg(\'"\')<Bar>let old_regtype=getregtype(\'"\')<CR>gvy:let @/=\'\\V\'.escape(getreg(\'"\'), \'\\\')<CR>:call setreg(\'"\', old_reg, old_regtype)<CR>:set hlsearch<CR>')
map('n', '<leader>/', ':set hlsearch<CR>:let @/=\'\\<<C-R><C-W>\\>\'<CR>')
map('n', '<C-\\>', ':ZemEdit !<C-R><C-W><CR>zz')
map('n', '<leader><C-\\>', ':ZemEdit =P =D !<C-R><C-W><CR>zz')
map('n', '<C-B>',
    ':exe ":sign place ".bufnr("%")."200".line(".")." name=HL line=".line(".")." file=".expand("%:p")<CR>mMj')
map('n', 'cc', 'yiw')
map('i', '<C-F>', '<C-R>=CompleteFile()<CR>')
map('n', '<C-L>', function()
    ClearHighlights()
    ClearMatches()
    vim.cmd("normal <C-L>")
    vim.opt.hlsearch = true
    vim.cmd("nohlsearch")
end
)
map('n', '<C-N>', ':exe ":sign unplace ".bufnr("%")."200".line(".")<CR>')
map('n', '<C-P>', ':ZemPreviewEdit !<C-R><C-W><CR>')
map('c', '<C-R><C-R>', '<C-R>+')
map('i', '<C-R><C-R>', '<C-R>+')
map('n', '<C-S>', ':wa<CR>')
map('i', '<C-S>', '<ESC>:update<CR>')
map('i', '<C-SPACE>', '<C-X><C-O>')
map('n', '<C-W>a', ':cclose<CR>')
map('t', '<Esc>', '<C-\\><C-n>')
map('n', '<F2>', ':cprev<CR><F3>')
map('n', '<leader><F2>', ':cpf<CR><F3>')
map('n', '<F3>', 'zz<cmd>let b:cc=execute(\':cc\')<CR><cmd>cc<CR>zz')
map('n', '<leader><F3>', '<cmd>cbuffer<CR><F3>')
map('n', '<F4>', ':cnext<CR><F3>')
map('n', '<leader><F4>', ':cnf<CR><F3>')
map('i', '<F2>', '<ESC><F2>')
map('i', '<F3>', '<ESC><F3>')
map('i', '<F4>', '<ESC><F4>')
map('i', '<F5>', '<ESC><F5>')
map('i', '<F6>', '<ESC><F6>')
map('i', '<F7>', '<ESC><F7>')
map('n', '<F5>', ':Build<CR>')
map('n', '<leader><F5>', '<cmd>BuildAll<CR>')
map('n', '<F6>', ':Test<CR>')
map('n', '<leader><F6>', '<cmd>TestAll<CR>')
map('n', '<F7>', 'gg:Check<CR>')
map('n', '<leader><F7>', 'gg:CheckAll<CR>')
map('n', '<leader><leader>', '<cmd>lua edit_related_file()<CR>')
map('n', '[;', '0<CMD>?: ; <CR><CMD>nohlsearch<CR>')
map('n', '];', '0<CMD>/: ; <CR><CMD>nohlsearch<CR>')
map('v', '>', '>gv')
map('v', '<', '<gv')
map('n', '<leader>?', ':call MatchAdd("<C-R><C-W>")<CR>')
map('v', '<leader>?', 'y:call MatchAdd("<C-R>"")<CR>')
map('n', '<leader>A', 'vip:EasyAlign*\\ {\'indentation\':\'shallow\', \'ignore_groups\':[]}<CR>')
map('n', '<leader>a', 'vip<Plug>(LiveEasyAlign)')
map('v', '<leader>A', ':EasyAlign*\\ {\'indentation\':\'shallow\', \'ignore_groups\':[]}<CR>')
map('v', '<leader>a', '<Plug>(LiveEasyAlign)')
map('o', 'a*', ':<C-U>call TextObjComment(0)<CR>')
map('v', 'a*', '<ESC>:<C-U>call TextObjComment(0)<CR>')
map('n', '<leader>b', ':Breakpoint <CR>')
map('n', '<leader>C', '<C-W>z:%argdel<CR>:%bd<CR>')
map('n', '<leader>c', '<C-W>z:bd<CR>')
map('n', '<leader>dg', ':diffget<CR>')
map('v', '<leader>dg', ':diffget<CR>')
map('n', '<leader>dr', ':diffget REMOTE<CR>')
map('n', '<leader>dl', ':diffget LOCAL<CR>')
map('n', '<leader>db', ':diffget BASE<CR>')
map('v', '<leader>dr', ':diffget REMOTE<CR>')
map('v', '<leader>dl', ':diffget LOCAL<CR>')
map('v', '<leader>db', ':diffget BASE<CR>')
map('n', '<leader>dp', ':diffput<CR>')
map('v', '<leader>dp', ':diffput<CR>')
map('n', '<leader>du', ':diffupdate<CR>')
map('n', '<leader>dt', ':diffthis<CR>')
map('n', '<leader>e', 'O<c-a> = <Esc>p')
map('n', '<space>f', '<cmd>update<cr><cmd>silent ! $NIX_FMT %<CR>')
map('n', '<leader>G', '<cmd>tab Git<CR>')
map('n', 'gz', ':ZemEdit !<C-R><C-W><CR>zz')
map('n', 'gf', 'gF')
map('n', 'gF', ':e <cfile>')
map('n', '<leader>H', ':e <C-R>=expand("%:h")<CR>/')
map('n', '<leader>i', ':Import<CR>')
map('o', 'i*', ':<C-U>call TextObjComment(1)<CR>')
map('v', 'i*', '<ESC>:<C-U>call TextObjComment(1)<CR>')
map('n', '<leader>l', function() vim.fn.setreg('+', GetFilenameAndLine()) end)
map('n', '<leader>m', ':exe \'edit \'.FindBuildFile("")<CR>')
map('n', '<leader>M', ':exe \'edit \'.FindBuildFile("!")<CR>')
map('n', '<leader>n', ':bn<CR>')
map('n', '<leader>N', ':bp<CR>')
map('n', 'Q', '@q')
map('v', 'Q', '@q')
map('v', '<leader>r,',
    ':<C-U>let old_reg=getreg(\'"\')<Bar>let old_regtype=getregtype(\'"\')<CR>gv""s<C-R>=join(reverse(split(@",\'\\s*,\\s*\')),\', \')<CR><ESC>:call setreg(\'"\', old_reg, old_regtype)<CR>')
map('v', '<leader>r=',
    ':<C-U>let old_reg=getreg(\'"\')<Bar>let old_regtype=getregtype(\'"\')<CR>gv""s<C-R>=join(reverse(split(@",\'\\s*=\\s*\')),\' = \')<CR><ESC>:call setreg(\'"\', old_reg, old_regtype)<CR>')
map('n', '<leader>R', ':Rename <C-R>=expand("%")<CR>')
-- TODO: fix map('v', '<leader>s', '""y:%s/<C-R>=substitute(escape(@", \'?.\\*$^~[/\'), \'\\_s\\+\', \'\\\\\_s\\\\+\', \'g\')<CR>/<C-R>=substitute(escape(@", \'?.\\*$^~[/\'), \'\\_s\\+\', \'\\\\\_s\\\\+\', \'g\')<CR>/gc<left><left><left>')
-- TODO: fix map('n', '<leader>s', '""yiw:%s/\\<<C-R>=substitute(escape(@", \'?.\\*$^~[/\'), \'\\_s\\+\', \'\\\\\_s\\\\+\', \'g\')<CR>\\>/<C-R>=substitute(escape(@", \'?.\\*$^~[/\'), \'\\_s\\+\', \'\\\\\_s\\\\+\', \'g\')<CR>/gc<left><left><left>')
map({ 'n', 'v' }, '<leader>S', ':%s/[ \\r\\t]\\+$//e<CR>')
map('n', '<leader>T', TerminalOpen)
map('n', '<leader>t', ':tabnew<CR>:set buftype=nofile<CR>')
map('n', '<leader>v', '<cmd>grep "\\b<C-R><C-W>\\b"')
map('n', 'Z', ':Zem<CR>')
map('n', 'z0', ':set foldlevel=99<CR>')
map('n', 'z1', ':set foldlevel=0<CR>')
map('n', 'z2', ':set foldlevel=1<CR>')
map('n', 'z3', ':set foldlevel=2<CR>')
map('n', 'z4', ':set foldlevel=3<CR>')
map('n', '<leader>zd', ':ZemEdit =Proto =Def !<C-R><C-W><CR>')
map('n', '<leader>ze', ':ZemEdit <C-R><C-W><CR>')
map('n', '<leader>zf', ':ZemEdit /<C-R><C-F><CR>')
map('n', '<leader>zi', ':call FixMissingInclude("<C-R><C-W>")<CR>')
map('n', '<leader>zp', ':ZemPreviewEdit !<C-R><C-W><CR>')
map('n', '<leader>zt', ':ZemTabEdit !<C-R><C-W><CR>')
map('n', '<leader>zu', ':ZemUpdate<CR>')
map('n', '<leader>zU', ':Zem =Use !<C-R><C-W>')
map('n', '<leader>zz', ':Zem !<C-R><C-W><CR>')
map('n', '<leader>za', ':call AllZemMatches("!<C-R><C-W>")<CR>')
map('n', '<C-1>', '1<C-W><C-W>')
map('n', '<C-2>', '2<C-W><C-W>')
map('n', '<C-3>', '3<C-W><C-W>')
map('n', '<C-4>', '4<C-W><C-W>')
map('n', '<C-5>', '5<C-W><C-W>')
map('n', '<C-6>', '6<C-W><C-W>')
map('i', '<C-1>', '<ESC>1<C-W><C-W>')
map('i', '<C-2>', '<ESC>2<C-W><C-W>')
map('i', '<C-3>', '<ESC>3<C-W><C-W>')
map('i', '<C-4>', '<ESC>4<C-W><C-W>')
map('i', '<C-5>', '<ESC>5<C-W><C-W>')
map('i', '<C-6>', '<ESC>6<C-W><C-W>')

-- CTRL-W is a bad habit, it closed so many tabs
map('i', '<C-W>', '<cmd>echo "DONT"<CR>')
map('c', '<C-W>', '<cmd>echo "DONT"<CR>')

map('n', '<F11>', '<cmd>earlier<CR>')
map('n', '<F12>', '<cmd>later<CR>')

function LspMappings()
    local opts = { buffer = true }
    map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    map('i', '<C-k>', vim.lsp.buf.signature_help, opts)
    map('n', '<space>/', vim.lsp.buf.document_highlight, opts)
    map('n', '<space>d', vim.lsp.buf.type_definition, opts)
    map('n', '<space>a', vim.lsp.buf.code_action, opts)
    map('v', '<space>a', vim.lsp.buf.code_action, opts)
    map('n', '<space>e', function() vim.diagnostic.open_float({ scope = "line" }) end, opts)
    map('n', '<space>f', vim.lsp.buf.format, opts)
    map('v', '<space>f', vim.lsp.buf.format, opts)
    map('n', '<space>h', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, opts)
    map('n', '<space>q', vim.diagnostic.setqflist, opts)
    map('n', '<space>r', vim.lsp.buf.rename, opts)
    map('n', '<space>s', vim.lsp.buf.workspace_symbol, opts)
    map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    map('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', '[d', vim.diagnostic.goto_prev, opts)
    map('n', ']d', vim.diagnostic.goto_next, opts)
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'gi', vim.lsp.buf.implementation, opts)
    map('n', 'gr', vim.lsp.buf.references, opts)
end

-- }}}

-- {{{ Abbreviations

vim.cmd('cabbr <expr> %% expand(\'%\')')
vim.cmd('cabbr <expr> %H expand(\'%:h\')')
vim.cmd('cabbr <expr> %P expand(\'%:p\')')
vim.cmd('cabbr <expr> %R expand(\'%:r\')')
vim.cmd('cabbr <expr> %T expand(\'%:t\')')

-- }}}

-- LSP {{{

-- LSP Attach Handler
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        LspMappings()
        LspCommands()
    end,
})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    float = true,
    update_in_insert = true,
    underline = false,
    severity_sort = true,
})

for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
    vim.api.nvim_set_hl(0, group, {})
end

-- {{{ Rust
local clippy
if vim.fn.executable("cargo-hippie-with-clippy") == 1 then
    clippy = "hippie-with-clippy"
else
    clippy = "clippy"
end

vim.lsp.config('rust_analyzer', {
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "item",
                },
                group = {
                    enable = true,
                },
            },
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
            },
            rustc = {
                source = "/Users/matthias.riegel/pro/rust/Cargo.toml",
            },
            completion = {
                postfix = {
                    enabled = true,
                },
                privateEditable = {
                    enabled = true,
                },
            },
            hover = {
                actions = {
                    references = {
                        enabled = true,
                    },
                },
            },
            check = {
                command = clippy,
            },
            diagnostics = {
                disabled = {
                    "unlinked-file",
                    "inactive-code",
                },
            },
        }
    }
})
vim.lsp.enable('rust_analyzer')
-- }}}

-- {{{ Nix
vim.lsp.config('nil_ls', {
    settings = {
        ["nil"] = {
            formatting = { "nixfmt" },
        },
    },
})
vim.lsp.enable('nil_ls')
-- }}}

-- {{{ Python
vim.lsp.config('pylsp', {
    settings = {
        pylsp = {
            configurationSources = { "flake8" },
            formatCommand = { "black" },
            plugins = {
                flake8 = {
                    enabled = true,
                    ignore = { 'E1', 'E2', 'E3', 'E5', "E74", 'W1', 'W2', 'W3', 'W5' },
                    maxLineLength = 25,
                },
                isort = {
                    enabled = true,
                },
            }
        },
    },
})
vim.lsp.enable('pylsp')
-- }}}

-- {{{ Clangd
vim.lsp.config('clangd', {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--cross-file-rename",
        "--header-insertion=iwyu",
        "--log=info",
    },
    root_dir = function(fname)
        return vim.fs.root(fname, { "compile_flags.txt" }) or "."
    end
})
vim.lsp.enable('clangd')
-- }}}

-- {{{ Lua
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})
vim.lsp.enable('lua_ls')
-- }}}

-- }}} LSP

-- Load local.vim if it exists
if vim.fn.filereadable(vim.fn.expand('<sfile>:h') .. '/local.vim') == 1 then
    vim.cmd('source ' .. vim.fn.expand('<sfile>:h') .. '/local.vim')
end

vim.opt.secure = true
vim.cmd('nohlsearch')
