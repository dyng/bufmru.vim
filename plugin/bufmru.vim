let s:buf_mru = []

function! g:BufMRUAdd(bufnr)
    let bufnr = str2nr(a:bufnr)
    call g:BufMRUDel(bufnr)
    if buflisted(bufnr)
        call add(s:buf_mru, bufnr)
    endif
endfunction

function! g:BufMRUDel(bufnr)
    let bufnr = str2nr(a:bufnr)
    let idx   = index(s:buf_mru, bufnr)
    if idx >= 0
        call remove(s:buf_mru, idx)
    endif
endfunction

function! g:BufMRUList()
    return s:buf_mru
endfunction

augroup BufMRUAuCmd
    autocmd!
    au BufAdd    * call g:BufMRUAdd(expand('<abuf>'))
    au BufEnter  * call g:BufMRUAdd(expand('<abuf>'))
    au BufDelete * call g:BufMRUDel(expand('<abuf>'))
augroup END
