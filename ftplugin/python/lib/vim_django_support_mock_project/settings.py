# vim: set fileencoding=utf8:
#
# Mock of django settings
import os
ROOT=os.path.dirname(os.path.abspath(__file__))
DEBUG = True
TEMPLATE_DEBUG = DEBUG
ADMINS = []
MANAGERS = ADMINS
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(ROOT, 'temp.db'),
    },
}
TIME_ZONE = ''
LANGUAGE_CODE = ''
SITE_ID = 1
USE_I18N = True
USE_L10N = True
MEDIA_ROOT = ''
MEDIA_URL = ''
STATIC_ROOT = ''
SECRET_KEY = 'this value cannnot be empty from django 1.4'
STATIC_URL = ''
STATICFILES_DIRS = []
STATICFILES_FINDERS = []
TEMPLATE_LOADERS = []
MIDDLEWARE_CLASSES = []
TEMPLATE_CONTEXT_PROCESSORS = []
ROOT_URLCONF = ''
TEMPLATE_DIRS = []
INSTALLED_APPS = []

import django
if django.VERSION < (1, 4, 1):
    ADMIN_MEDIA_PREFIX = ''
