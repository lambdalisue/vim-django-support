if exists("g:django_support_loaded")
  finish
endif
let g:django_support_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

command! DjangoSupportActivate call django_support#activate(2)
command! DjangoSupportDeactivate call django_support#deactivate(2)

nnoremap <silent> <Plug>(django-support-activate)
      \ :call django_support#activate(2)<CR>

nnoremap <silent> <Plug>(django-support-deactivate)
      \ :call django_support#deactivate(2)<CR>

if g:django_support#auto_activate == 1
  call django_support#activate(0)
  if g:django_support#auto_activate_on_filetype == 1
    augroup django_support
      autocmd!
      autocmd FileType python,htmldjango call django_support#activate(0)
    augroup END
  endif
endif

let &cpo = s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker
