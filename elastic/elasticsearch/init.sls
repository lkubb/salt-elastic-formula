# -*- coding: utf-8 -*-
# vim: ft=sls
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ tplroot ~ '.common' }}
  - .package
  - .config
  - .certs
  - .bootstrap_pass
  - .service
{%- if elastic.elasticsearch.vault.es_host %}
  - .auth
  - .vault_roles
{%- endif %}
