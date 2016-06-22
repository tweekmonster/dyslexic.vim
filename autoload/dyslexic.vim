function! s:uniq_add(list, item) abort
  if a:item != s:word && index(a:list, a:item) == -1
    call add(a:list, a:item)
  endif
endfunction


function! s:setmatch(pattern) abort
  if exists('b:matchid') && b:matchid
    silent! call matchdelete(b:matchid)
    let b:matchid = 0
  endif

  if !empty(a:pattern)
    let b:matchid = matchadd('Dyslexic', a:pattern)
  endif
endfunction


function! dyslexic#highlihgt(cursor) abort
  let s:word = expand('<cword>')
  if a:cursor && get(b:, 'dyslexic_word', '') ==? s:word
    return
  elseif !a:cursor && exists('#dyslexic#CursorMoved#<buffer>')
    autocmd! dyslexic CursorMoved <buffer>
  endif

  let b:dyslexic_word = s:word
  call s:setmatch('')

  if empty(s:word)
    return
  endif

  if s:word !~# '^\k\+$'
    if !a:cursor
      echohl ErrorMsg
      echo '[dyslexic] "'.s:word.'" is not a valid word'
      echohl None
    endif
    return
  endif

  if len(s:word) < 3
    if !a:cursor
      echohl WarningMsg
      echo '[dyslexic] "'.s:word.'" is too short'
      echohl None
    endif
    return
  endif

  let letter_swaps = []
  let letter_missing = []
  let letter_oneoff = []
  let letter_additional = []

  for i in range(len(s:word))
    let head = strpart(s:word, 0, i + 1)
    let c1 = strpart(s:word, i + 1, 1)
    let c2 = strpart(s:word, i + 2, 1)
    let tail = strpart(s:word, i + 3)

    if len(head) == 1
      call s:uniq_add(letter_swaps, c1.head.c2.tail)
      call s:uniq_add(letter_missing, c1.c2.tail)
      call s:uniq_add(letter_oneoff, '[^'.head.']'.c1.c2.tail)
      call s:uniq_add(letter_additional, head.'\k\{1,2}'.c1.c2.tail)
    endif

    if !empty(c1) && !empty(c2)
      call s:uniq_add(letter_swaps, head.c2.c1.tail)
      call s:uniq_add(letter_missing, head.c2.tail)
      call s:uniq_add(letter_oneoff, head.'[^'.c1.']'.c2.tail)
      call s:uniq_add(letter_additional, head.c1.'\k\{1,2}'.c2.tail)
    else
      break
    endif
  endfor

  call s:uniq_add(letter_missing, strpart(s:word, 0, len(s:word) - 1))
  call s:uniq_add(letter_oneoff, strpart(s:word, 0, len(s:word) - 1).'[^'.strpart(s:word, len(s:word)-1).']')
  call s:uniq_add(letter_additional, s:word.'\k\{1,2}')

  let pattern = '\c\<\%('.join(
        \ letter_swaps +
        \ letter_missing +
        \ letter_oneoff +
        \ letter_additional, '\|').'\)\>'

  try
    silent execute 'lvimgrep /'.pattern.'/gj %'
  catch /E480/
    if !a:cursor
      echohl MoreMsg
      echo '[dyslexic] No variations of "'.s:word.'"'
      echohl None
      lclose
    endif
    return
  finally
    call s:setmatch(pattern)
  endtry

  let loclist = getloclist(winnr())
  " Trim the matches
  for item in loclist
    let item.text = '...'.matchstr(item.text,
          \ '\s*\zs.\{,20}\%'.item.col.'c.\{,20}\ze').'...'
  endfor

  call setloclist(winnr(), loclist, 'r', 'variations of "'.s:word.'"')
  if !a:cursor
    keepalt belowright lopen
    call s:setmatch(pattern)
    syntax match qfFileName "[^|]*" contained nextgroup=qfSeparator
    syntax match qfHiddenPath '^\%([^/]\+/\)*' conceal nextgroup=qfFileName
    if &l:conceallevel == 0
      setlocal conceallevel=1
    endif
    wincmd p
  endif
endfunction


function! dyslexic#off() abort
  call s:setmatch('')
  lclose
  if exists('#dyslexic#CursorMoved#<buffer>')
    unlet! b:dyslexic_word
    autocmd! dyslexic CursorMoved <buffer>
  endif
endfunction


function! dyslexic#toggle_tracking() abort
  if exists('#dyslexic#CursorMoved#<buffer>')
    call dyslexic#off()
  else
    augroup dyslexic
      autocmd! CursorMoved <buffer> call dyslexic#highlihgt(1)
    augroup END
    call dyslexic#highlihgt(1)
  endif
endfunction
