"==============================================================================
" vim-django-support
"
" Add DJANGO_SETTINGS_MODULE to enable Django on Vim.
"
" Author:   Alsiue <lambdalisue@hashnote.net>
" License:  MIT license
"==============================================================================
let s:save_cpo = &cpo
set cpo&vim

" Variables
let s:repository_root = fnameescape(expand('<sfile>:p:h:h'))

"------------------------------------------------------------------------------
" Utility functions
"------------------------------------------------------------------------------

" Add PYTHONPATH
function! s:add_pythonpath(path)
  if has('win16') || has('win32') || has('win64')
    let delimiter = ';'
  else
    let delimiter = ':'
  endif
  let pathlist = split($PYTHONPATH, delimiter)
  if isdirectory(a:path) && index(pathlist, a:path) == -1
    let $PYTHONPATH = a:path . delimiter . $PYTHONPATH
  endif
endfunction

" Remove PYTHONPATH
function! s:remove_pythonpath(path)
  if has('win16') || has('win32') || has('win64')
    let delimiter = ';'
  else
    let delimiter = ':'
  endif
  let pathlist = split($PYTHONPATH, delimiter)
  let found = index(pathlist, a:path)
  if found != -1
    if found == 0
      let pathlist = pathlist[1:]
    else
      let pathlist = pathlist[:found-1] + pathlist[found+1:]
    endif
    let $PYTHONPATH = join(pathlist, delimiter)
  endif
endfunction

" Find specified module absolute path
function! s:find_module(root, module_name)
  " try to find the module file in sub directories
  let ff = findfile(a:module_name . '.py', a:root . '/**')
  if len(ff) != 0
    return fnamemodify(ff, ':p:r')
  endif
  " try to find module directory in sub directories
  let fd = finddir(a:module_name, a:root . '/**')
  if len(fd) != 0
    return fnamemodify(ff, ':p')
  endif
  " not found
  return ''
endfunction


"------------------------------------------------------------------------------
" vim-django-support main functions
"------------------------------------------------------------------------------

" Get project root path
function! django_support#get_project_root()
  if len(get(b:, 'django_support_project_root', '')) > 0
    return b:django_support#project_root
  elseif len(g:django_support#project_root) > 0
    return g:django_support#project_root
  else
    return getcwd()
  endif
endfunction

" Get django settings module
function! django_support#get_settings_module()
  let project_root = django_support#get_project_root()
  let settings_module_name = g:django_support#settings_module_name
  let settings_module = s:find_module(project_root, settings_module_name)
  let fsettings_module = s:repository_root . '/lib/vim-django-support/settings'
  return (len(settings_module) == 0 ? fsettings_module : settings_module)
endfunction

" Return current django setttings
function! django_support#statusline()
  if g:django_support#activated == 0
    return ''
  else
    let project_name = g:django_support#activated_info.project_name
    let project_module = g:django_support#activated_info.project_module
    return project_name . "." . project_module
  endif
endfunction
    
" Activate vim-django-support
function! django_support#activate(verbose)
  let l:verbose = (a:verbose == 2 ? g:django_support#verbose : a:verbose)
  if g:django_support#activated != 0
    if a:verbose == 1
      echoerr "vim-django-support is already activated"
    endif
  else
    " Find settings module
    let settings_module = django_support#get_settings_module()
    let project_parent = fnamemodify(settings_module, ':h:h')
    let project_name = fnamemodify(settings_module, ':h:t')
    let project_module = fnamemodify(settings_module, ':t')
    " Add PYTHONPATH
    call s:add_pythonpath(project_parent)
    " Configure DJANGO_SETTINGS_MODULE
    let $DJANGO_SETTINGS_MODULE = project_name . "." . project_module
    " change the status variable
    let g:django_support#activated = 1
    let g:django_support#activated_info = {
          \ 'project_parent': project_parent,
          \ 'project_name': project_name,
          \ 'project_module': project_module,
          \ }
    if l:verbose == 1
      echomsg 'vim-django-support is activated'
    endif
  endif
endfunction

" Deactivate vim-django-support
function! django_support#deactivate(verbose)
  let l:verbose = (a:verbose == 2 ? g:django_support#verbose : a:verbose)
  if get(g:, 'django_support#activated', 0) == 0
    if a:verbose == 1
      echoerr "vim-django-support have not activated yet"
    endif
  else
    " Remove PYTHONPATH
    call s:remove_pythonpath(g:django_support#activated_info.project_parent)
    " Configure DJANGO_SETTINGS_MODULE (vim cannot remove env variables?)
    let $DJANGO_SETTINGS_MODULE = ''
    " change the status variable
    let g:django_support#activated = 0
    if l:verbose == 1
      echomsg 'vim-django-support is deactivated'
    endif
  endif
endfunction

"------------------------------------------------------------------------------
" default settings
"------------------------------------------------------------------------------
let s:settings = {
      \ 'auto_activate': 1,
      \ 'auto_activate_on_filetype': 1,
      \ 'verbose': 1,
      \ 'activated': 0,
      \ 'settings_module_name': "'settings'",
      \ 'project_root': "''",
      \ }

function! s:init()
  for [key, val] in items(s:settings)
    if !exists('g:django_support#'.key)
      exe 'let g:django_support#'.key.' = '.val
    endif
  endfor
endfunction
call s:init()

let &cpo = s:save_cpo
unlet! s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker
