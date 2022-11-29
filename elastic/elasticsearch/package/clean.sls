# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.elasticsearch.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_clean }}

Elasticsearch is absent:
  pkg.removed:
    - name: {{ elastic.lookup.pkg.elasticsearch }}
    - require:
      - sls: {{ sls_config_clean }}
