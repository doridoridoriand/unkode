#!/usr/bin/env python
# coding: UTF-8

# This script runs on only python2.x environment.

import urllib2
from bs4 import BeautifulSoup

import pdb

html = urllib2.urlopen('https://www.python.org/downloads/')
soup = BeautifulSoup(html, 'html.parser')

li = soup.find_all('li')


pdb.set_trace()
