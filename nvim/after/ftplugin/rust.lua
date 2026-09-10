vim.cmd([[iabbrev <buffer> tmod #[cfg(test)]<cr>mod test {<cr>use super::*;<cr>#[test]<cr> fn test () {<cr>todo!();<cr>}<cr>}<up><up><end>]])
vim.cmd("compiler! cargo")
