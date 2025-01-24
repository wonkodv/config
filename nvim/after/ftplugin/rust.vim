
if exists("g:dont_overwrite_build_commands")
    " asdfg
else
    command! Build :Make! cargo run
    command! Test :Make! cargo test --workspace
    command! Check :Make! cargo fmt && cargo clippy
endif

function! FindBuildFile()
    let m = FindInParent(expand("%"), "Cargo.toml")
    if m != ""
      return m
    endif
    return "Cargo.toml"
endfunction

abbreviate <buffer> tmod #[cfg(test)]<cr>mod test {<cr>use super::*;<cr>#[test]<cr> fn test () {<cr>todo!();<cr>}<cr>}<up><up><end>
abbreviate <buffer> ass assert!();<Left><Left>
abbreviate <buffer> aeq assert_eq!(,);<Left><Left><Left>

setl efm+=%E%.%#panicked\ at\ %f:%l:%c:
setl efm+=%Z%m

lua << EOF

function RustRunnables()
    function handler(_, result)
        vim.pretty_print("================================")
        vim.pretty_print(result)
    end
    local ctx = {
        textDocument=vim.lsp.util.make_text_document_params(0),
        position = nil
    }
    vim.lsp.buf_request(0, "experimental/runnables", ctx, handler)
end


EOF

command RustRunnables :lua RustRunnables()<CR>
