# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.heartbeat.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_package_install }}

Heartbeat configuration is managed:
  file.serialize:
    - name: {{ elastic.lookup.config.heartbeat | path_join("heartbeat.yml") }}
    - mode: 644
    - user: root
    - group: {{ elastic.lookup.group.heartbeat }}
    - makedirs: True
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ elastic.heartbeat.config | json }}
