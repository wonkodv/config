if not vim.g.dont_overwrite_build_commands then
    vim.api.nvim_buf_create_user_command(0, 'Build', function()
        Make('!', 'cargo build')
    end, {})

    vim.api.nvim_buf_create_user_command(0, 'Test', function()
        Make('!', 'cargo test --workspace')
    end, {})

    vim.api.nvim_buf_create_user_command(0, 'Check', function()
        Make('!', 'cargo fmt && cargo clippy')
    end, {})
end

function FindBuildFile(bang)
    if bang ~= '!' then
        return FindInParent(vim.fn.expand("%"), "Cargo.toml")
    else
        return "Cargo.toml"
    end
end

vim.cmd([[iabbrev <buffer> tmod #[cfg(test)]<cr>mod test {<cr>use super::*;<cr>#[test]<cr> fn test () {<cr>todo!();<cr>}<cr>}<up><up><end>]])
vim.cmd([[iabbrev <buffer> ass assert!();<Left><Left>]])
vim.cmd([[iabbrev <buffer> aeq assert_eq!(,);<Left><Left><Left>]])

-- vim.opt_local.errorformat:append('%E%.%#panicked\\ at\\ %f:%l:%c:')
-- vim.opt_local.errorformat:append('%Z%m')

function RustRunnables()
    local function handler(_, result)
        vim.pretty_print("================================")
        vim.pretty_print(result)
    end
    local ctx = {
        textDocument = vim.lsp.util.make_text_document_params(0),
        position = nil
    }
    vim.lsp.buf_request(0, "experimental/runnables", ctx, handler)
end

vim.api.nvim_buf_create_user_command(0, 'RustRunnables', function()
    RustRunnables()
end, {})
