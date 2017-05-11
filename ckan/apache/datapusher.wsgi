import os
import sys
import hashlib

activate_this = os.path.join('/usr/lib/ckan/datapusher/bin/activate_this.py')
execfile(activate_this, dict(__file__=activate_this))

import ckanserviceprovider.web as web
#config_filepath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'development.ini')
os.environ['JOB_CONFIG'] = '/etc/ckan/datapusher/datapusher_settings.py'
web.init()

import datapusher.jobs as jobs

application = web.app

