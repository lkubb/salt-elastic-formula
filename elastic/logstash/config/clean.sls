# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.logstash.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Logstash configuration is absent:
  file.absent:
    - name: {{ elastic.lookup.config.logstash | path_join("logstash.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
