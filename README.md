vim-django-support
======================
As many of you know, [django][] use an environment variable call
`DJANGO_SETTINGS_MODULE` to determine the settings like which database system
should django use.

While django use the environment variable in module definition level, some of
django modules could not be loaded without the correct value.
This is quite annoying and Vim omnicompletion system like [pythoncomplete][]
could not parse the djanog module, and thus often the omni completion of django
is not available in Vim.

vim-django-support automatically find the `settings` module from the current
working directory and apply that to `DJANGO_SETTINGS_MODULE`.
This makes Vim internal python allows to load django modules, and allows to
do omni completions.

[django]:   https://www.djangoproject.com/
[pythoncomplete]: http://www.vim.org/scripts/script.php?script_id=1542


Install
---------------------
I recommend you to use some package manager such as [neobundle.vim][] or
[Vundle.vim][].
The following is an example in [neobundle.vim][]

```vim
NeoBundle 'lambdalisue/vim-django-support'
```

[neobundle.vim]: https://github.com/Shougo/neobundle.vim
[Vundle.vim]: https://github.com/gmarik/Vundle.vim

Requirements
---------------------
vim-django-support use pure vim script to find the `settings` module thus what
you need to do is just install it. It has no dependencies.


Usage
---------------------
With default settings, vim-django-support try to find the `settings` module
in a directory tree from the current directory (the current directory and its
sub directories) everytime you open a file which file type is 'python' or
'htmldjango'.
If you prefer to use a different directory rather than the current directory,
you can specify the directory with `g:django_support#project_root` or
`b:django_support#project_root`.
If you don't want vim-django-support to find the `settings` module everytime
when you open the pytyon file, specify `0` to 
`g:django_support#auto_activate_on_filetype`, and if you don't want
vim-django-support to activate in vim starting, specify `0` to
`g:django_support#auto_activate`.
