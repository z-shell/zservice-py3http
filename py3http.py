#!/usr/bin/env python3

# Three config values are used: servedir, bindhost, port

import sys
import os
from http.server import HTTPServer, SimpleHTTPRequestHandler
import configparser

config = configparser.ConfigParser()
config.read(sys.argv[1])

cwd = os.getcwd()
sdir = config['Main']['servedir']
sdir = sdir.replace("&PLUGIN&", cwd)
os.chdir(sdir)

httpd = HTTPServer((config['Main']['bindhost'], int(config['Main']['port'])), SimpleHTTPRequestHandler)
httpd.serve_forever()
