# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.filebeat.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Filebeat configuration is absent:
  file.absent:
    - name: {{ elastic.lookup.config.filebeat | path_join("filebeat.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
