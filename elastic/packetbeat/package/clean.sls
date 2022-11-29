# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.packetbeat.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_clean }}

Packetbeat is absent:
  pkg.removed:
    - name: {{ elastic.lookup.pkg.packetbeat }}
    - require:
      - sls: {{ sls_config_clean }}
