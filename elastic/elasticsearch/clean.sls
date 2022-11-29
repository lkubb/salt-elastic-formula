# -*- coding: utf-8 -*-
# vim: ft=sls
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
{%- if elastic.elasticsearch.vault.es_host %}
  - .auth.clean
{%- endif %}
  - .service.clean
  - .bootstrap_pass.clean
  - .certs.clean
  - .config.clean
  - .package.clean
