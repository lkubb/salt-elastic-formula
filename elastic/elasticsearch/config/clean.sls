# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.elasticsearch.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Elasticsearch configuration is absent:
  file.absent:
    - names:
      - {{ elastic.lookup.config.elasticsearch | path_join("elasticsearch.yml") }}
      - {{ salt["file.dirname"](elastic.lookup.config.elasticsearch) | path_join("jvm.options.d", "salt.options") }}
    - require:
      - sls: {{ sls_service_clean }}
