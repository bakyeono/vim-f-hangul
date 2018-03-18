scriptencoding utf-8

let s:HSTART = 44032
let s:HLAST = 55203
let s:HUNIT = 588

let s:hrange = {}
let s:hrange['ㄱ'] = { 'start': s:HSTART + s:HUNIT * 0 - 0, 'end': s:HSTART + s:HUNIT * 2 - 1 }
let s:hrange['ㄴ'] = { 'start': s:HSTART + s:HUNIT * 2 - 0, 'end': s:HSTART + s:HUNIT * 3 - 1 }
let s:hrange['ㄷ'] = { 'start': s:HSTART + s:HUNIT * 3 - 0, 'end': s:HSTART + s:HUNIT * 5 - 1 }
let s:hrange['ㄹ'] = { 'start': s:HSTART + s:HUNIT * 5 - 0, 'end': s:HSTART + s:HUNIT * 6 - 1 }
let s:hrange['ㅁ'] = { 'start': s:HSTART + s:HUNIT * 6 - 0, 'end': s:HSTART + s:HUNIT * 7 - 1 }
let s:hrange['ㅂ'] = { 'start': s:HSTART + s:HUNIT * 7 - 0, 'end': s:HSTART + s:HUNIT * 9 - 1 }
let s:hrange['ㅅ'] = { 'start': s:HSTART + s:HUNIT * 9 - 0, 'end': s:HSTART + s:HUNIT * 11 - 1 }
let s:hrange['ㅇ'] = { 'start': s:HSTART + s:HUNIT * 11 - 0, 'end': s:HSTART + s:HUNIT * 12 - 1 }
let s:hrange['ㅈ'] = { 'start': s:HSTART + s:HUNIT * 12 - 0, 'end': s:HSTART + s:HUNIT * 14 - 1 }
let s:hrange['ㅊ'] = { 'start': s:HSTART + s:HUNIT * 14 - 0, 'end': s:HSTART + s:HUNIT * 15 - 1 }
let s:hrange['ㅋ'] = { 'start': s:HSTART + s:HUNIT * 15 - 0, 'end': s:HSTART + s:HUNIT * 16 - 1 }
let s:hrange['ㅌ'] = { 'start': s:HSTART + s:HUNIT * 16 - 0, 'end': s:HSTART + s:HUNIT * 17 - 1 }
let s:hrange['ㅍ'] = { 'start': s:HSTART + s:HUNIT * 17 - 0, 'end': s:HSTART + s:HUNIT * 18 - 1 }
let s:hrange['ㅎ'] = { 'start': s:HSTART + s:HUNIT * 18 - 0, 'end': s:HSTART + s:HUNIT * 19 - 1 }

let s:alias = {}
let s:alias['q'] = s:hrange['ㅂ']
let s:alias['w'] = s:hrange['ㅈ']
let s:alias['e'] = s:hrange['ㄷ']
let s:alias['r'] = s:hrange['ㄱ']
let s:alias['t'] = s:hrange['ㅅ']
let s:alias['a'] = s:hrange['ㅁ']
let s:alias['s'] = s:hrange['ㄴ']
let s:alias['d'] = s:hrange['ㅇ']
let s:alias['f'] = s:hrange['ㄹ']
let s:alias['g'] = s:hrange['ㅎ']
let s:alias['z'] = s:hrange['ㅋ']
let s:alias['x'] = s:hrange['ㅌ']
let s:alias['c'] = s:hrange['ㅊ']
let s:alias['v'] = s:hrange['ㅍ']

let g:history = ''

let s:forward = 'zps'
let s:backward = 'pbs'
let s:backwardEnd = 'pbes'
let s:char = ''
let s:cmd = ''

function! VimFHangul#forwardLookup() range

    let s:char = nr2char(getchar())
    call s:lookup(v:count1, s:forward)
    let s:cmd = 'f'

endfunction

function! VimFHangul#backwardLookup() range

    let s:char = nr2char(getchar())
    call s:lookup(v:count1, s:backward)
    let s:cmd = 'F'

endfunction

function! VimFHangul#tillBefore() range
    let s:char = nr2char(getchar())
    call s:tillBefore(v:count1, s:forward)
    let s:cmd = 't'
endfunction

function! VimFHangul#tillAfter() range
    let s:char = nr2char(getchar())
    call s:tillBefore(v:count1, s:backwardEnd)
    let s:cmd = 'T'

endfunction

" 검색에 사용할 regex string을 생성한다
function! s:createQuery(char)
    if !has_key(s:alias, a:char)
        return '['.escape(a:char, '\\').']'
    endif
    let l:alias = get(s:alias, a:char)
    let l:start = l:alias['start']
    let l:end = l:alias['end']
    return '['.escape(a:char, '\\').'\d'.l:start.'-\d'.l:end.']'
endfunction

" f, F 기능을 구현한다
function! s:lookup(count, flag)

    let l:searchStr = s:createQuery(s:char)
    let l:success = s:search(l:searchStr, a:flag)

    if l:success > 0
        let g:history = l:searchStr
    endif

    return l:success
endfunction

" t, T 기능(검색어 바로 앞에 커서를 점프)을 구현한다
function! s:tillBefore(count, flag)
    let l:searchStr = s:createQuery(s:char)

    if a:flag ==# s:forward
        let l:searchStr = '.' . l:searchStr
    elseif a:flag ==# s:backwardEnd
        let l:searchStr = l:searchStr . '.'
    endif

    let l:success = s:search(l:searchStr, a:flag)

    if l:success > 0
        let g:history = l:searchStr
    endif

endfunction

function! s:search(searchStr, flag)
    let l:success = 0
    let l:count = v:count1
    while l:count > 0
        if search(a:searchStr, a:flag, line('.')) < 1
            break
        endif
        let l:success += 1
        let l:count -= 1
    endwhile
    return l:success
endfunction

function! VimFHangul#repeat()

    if g:history == '' || s:cmd == ''
        return
    endif

    if s:cmd ==# 'f'
        call s:lookup(v:count1, s:forward)
        return
    elseif s:cmd ==# 'F'
        call s:lookup(v:count1, s:backward)
        return
    elseif s:cmd ==# 't'
        call s:tillBefore(v:count1, s:forward)
        return
    elseif s:cmd ==# 'T'
        call s:tillBefore(v:count1, s:backwardEnd)
        return
    endif

endfunction

function! VimFHangul#backwardRepeat()

    if g:history == '' || s:cmd == ''
        return
    endif

    if s:cmd ==# 'f'
        call s:lookup(v:count1, s:backward)
        return
    elseif s:cmd ==# 'F'
        call s:lookup(v:count1, s:forward)
        return
    elseif s:cmd ==# 't'
        call s:tillBefore(v:count1, s:backwardEnd)
        return
    elseif s:cmd ==# 'T'
        call s:tillBefore(v:count1, s:forward)
        return
    endif
endfunction
