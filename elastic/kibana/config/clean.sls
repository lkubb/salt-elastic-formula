# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.kibana.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Kibana configuration is absent:
  file.absent:
    - name: {{ elastic.lookup.config.kibana | path_join("kibana.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
