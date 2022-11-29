# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.kibana.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_package_install }}

Kibana configuration is managed:
  file.serialize:
    - name: {{ elastic.lookup.config.kibana | path_join("kibana.yml") }}
    - mode: 644
    - user: root
    - group: {{ elastic.lookup.group.kibana }}
    - makedirs: True
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ elastic.kibana.config | json }}
