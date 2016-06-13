highlight default Dyslexic ctermfg=0 ctermbg=6 guifg=#000000 guibg=#00ffff

command! -nargs=0 DyslexicTracking call dyslexic#toggle_tracking()
command! -nargs=0 DyslexicOff call dyslexic#off()

nnoremap <silent> <Plug>(Dyslexic) :call dyslexic#highlihgt(0)<cr>

let s:map = get(g:, 'dyslexic_map', '<localleader>*')
if !empty(s:map)
  execute 'nmap '.s:map.' <Plug>(Dyslexic)'
endif
unlet s:map
