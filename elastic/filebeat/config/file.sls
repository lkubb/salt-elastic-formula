# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.filebeat.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_package_install }}

Filebeat configuration is managed:
  file.serialize:
    - name: {{ elastic.lookup.config.filebeat | path_join("filebeat.yml") }}
    - mode: 644
    - user: root
    - group: {{ elastic.lookup.group.filebeat }}
    - makedirs: True
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ elastic.filebeat.config | json }}
