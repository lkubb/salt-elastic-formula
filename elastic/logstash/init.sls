# -*- coding: utf-8 -*-
# vim: ft=sls
{%- set tplroot = tpldir.split('/')[0] %}

include:
  - {{ tplroot ~ '.common' }}
  - .package
  - .config
  - .service
