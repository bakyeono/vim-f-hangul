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

let g:vim_f_hangul_history = ''
let g:vim_f_hangul_last_command = ''

function! VimFHangul#forwardLookup()

    let l:char = nr2char(getchar())
    let l:searchStr = ''

    let l:success = 0
    if has_key(s:alias, l:char)
        let l:alias = get(s:alias, l:char)
        let l:start = l:alias['start']
        let l:end = l:alias['end']
        let l:searchStr = '['.escape(l:char, '\\').'\d'.l:start.'-\d'.l:end.']'
    else
        let l:searchStr = '['.escape(l:char, '\\').']'
    endif

    let l:success = search(l:searchStr, 'zp', line('.'))
    let g:vim_f_hangul_history = l:searchStr
    let g:vim_f_hangul_last_command = 'f'

    if l:success > 0
    endif

endfunction

function! VimFHangul#backwardLookup()

    let l:char = nr2char(getchar())
    let l:searchStr = ''

    let l:success = 0
    if has_key(s:alias, l:char)
        let l:alias = get(s:alias, l:char)
        let l:start = l:alias['start']
        let l:end = l:alias['end']
        let l:searchStr = '['.escape(l:char, '\\').'\d'.l:start.'-\d'.l:end.']'
    else
        let l:searchStr = '['.escape(l:char, '\\').']'
    endif

    echo l:searchStr

    let l:success = search(l:searchStr, 'pb', line('.'))
    let g:vim_f_hangul_history = l:searchStr
    let g:vim_f_hangul_last_command = 'F'

    if l:success > 0
    endif

endfunction

function! VimFHangul#repeat()

    if g:vim_f_hangul_history == '' || g:vim_f_hangul_last_command == ''
        return
    endif

    let l:searchStr = g:vim_f_hangul_history

    if g:vim_f_hangul_last_command ==# 'f'
        call search(l:searchStr, 'zp', line('.'))
        return
    elseif g:vim_f_hangul_last_command ==# 'F'
        call search(l:searchStr, 'pb', line('.'))
        return
    endif

endfunction

function! VimFHangul#backwardRepeat()

    if g:vim_f_hangul_history == '' || g:vim_f_hangul_last_command == ''
        return
    endif

    let l:searchStr = g:vim_f_hangul_history

    if g:vim_f_hangul_last_command ==# 'f'
        call search(l:searchStr, 'pb', line('.'))
        return
    elseif g:vim_f_hangul_last_command ==# 'F'
        call search(l:searchStr, 'zp', line('.'))
        return
    endif
endfunction
