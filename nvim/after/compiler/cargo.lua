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


-- vim.opt_local.errorformat:append('%.%#panicked\\ at\\ %f:%l:%c:')
