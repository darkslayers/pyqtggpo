# -*- coding: utf-8 -*-

# define authorship information
__authors__ = ['papasi']
__author__ = ','.join(__authors__)
__credits__ = [
    ('Tony Cannon (Ponder), Tom Cannon (ProtomCannon)',
     'http://ggpo.net'),
    ('Pau Oliva Fora (@pof)',
     'http://poliva.github.io/ggpo/'),
]

__copyright__ = 'Copyright (c) 2014'
__license__ = 'GPL'

# define version information
__requires__ = ['PyQt4']
__version_info__ = (0, 0, 1)
__version__ = 'v%i.%02i.%02i' % __version_info__
__revision__ = __version__


def about():
    extra = ''
    for author, url in __credits__:
        extra += author + '\n' + url + "\n"
    return __copyright__ + ' ' + __author__ + "\n" + \
           'License: ' + __license__ + "\n" + \
           'Version: ' + __version__ + "\n" + \
           'Credits: ' + "\n" + extra