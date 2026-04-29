vim.cmd([[iabbrev <buffer> tmod #[cfg(test)]<cr>mod test {<cr>use super::*;<cr>#[test]<cr> fn test () {<cr>todo!();<cr>}<cr>}<up><up><end>]])
vim.cmd([[iabbrev <buffer> ass assert!();<Left><Left>]])
vim.cmd([[iabbrev <buffer> aeq assert_eq!(,);<Left><Left><Left>]])

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
