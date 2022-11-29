# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.filebeat.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_file }}

Filebeat is running:
  service.running:
    - name: {{ elastic.lookup.service.filebeat }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
