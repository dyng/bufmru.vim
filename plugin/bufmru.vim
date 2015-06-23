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

function! g:BufMRUUpdate()
    call filter(s:buf_mru, 'buflisted(v:val)')
endfunction

function! g:BufMRUList()
    return s:buf_mru
endfunction

function! g:BufMRUTruncate(max_buf_num)
    " Clone s:buf_mru first as we will iterate it while push/pop to s:buf_mru
    " is going on concurrently
    let buf_mru = copy(s:buf_mru)

    if len(buf_mru) <= a:max_buf_num
        return
    endif

    let need_to_delete = len(buf_mru) - a:max_buf_num
    for bufnr in buf_mru
        if !getbufvar(bufnr, "&modified") && bufwinnr(bufnr) == -1
            exec "bdelete " . bufnr
            let need_to_delete -= 1
            if need_to_delete <= 0
                break
            endif
        endif
    endfor
endfunction

augroup BufMRUAuCmd
    autocmd!
    au BufAdd,BufEnter * call g:BufMRUAdd(expand('<abuf>'))
    au BufDelete       * call g:BufMRUDel(expand('<abuf>'))

    if exists("g:bufmru_max_buffer_num")
        au BufAdd * nested call g:BufMRUTruncate(g:bufmru_max_buffer_num)
    endif
augroup END
