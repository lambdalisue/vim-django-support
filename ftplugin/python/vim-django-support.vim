"
" Vim script for supporting Django in vim
"
" This script simply add `DJANGO_SETTINGS_MODULE`
"
" Author: Alisue (lambdalisue@hashnote.net)
" Date: 2011/12/08
"
if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

py << EOF
import os
import sys
import vim

if sys.version_info[:2] < (2, 5):
    raise AssertionError('Vim must be compiled with Python 2.5 or higher; you have ' + sys.version)
# get the directory of this script is in
scriptroot = os.path.dirname(vim.eval('expand("<sfile>")'))
scriptroot = os.path.abspath(scriptroot)
def find_django_settings_module(root):
    root = os.path.abspath(root)
    project_name = os.path.basename(root)
    root = os.path.dirname(root)
    # Add path to current sys.path
    if root not in sys.path:
        sys.path.insert(0, root)
    # Enable to execute external command or make
    if 'PYTHONPATH' in os.environ:
        if root not in os.environ['PYTHONPATH']:
            os.environ['PYTHONPATH'] = u"%s:%s" % (os.environ['PYTHONPATH'], root)
    else:
        os.environ['PYTHONPATH'] = root
    return "%s.settings" % project_name
if 'DJANGO_SETTINGS_MODULE' not in os.environ:
    # try to find settings.py
    settings = None
    if os.path.exists('settings.py'):
        settings = find_django_settings_module('')
    elif os.path.exists(u'src'):
        files = os.listdir(u'src')
        for file in files:
            file = os.path.join('src', file)
            if os.path.exists(os.path.join(file, 'settings.py')):
                settings = find_django_settings_module(file)
                break
    if not settings:
        # use mock settings
        mock = os.path.join(scriptroot, r'lib/vim_django_support_mock_project')
        settings = find_django_settings_module(mock)
    os.environ['DJANGO_SETTINGS_MODULE'] = settings
    # Now try to load django.db. Without this code, pythoncomplete doesn't work correctly
    try:
        import django.db
    except ImportError:
        pass
EOF
