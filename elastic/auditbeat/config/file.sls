# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.auditbeat.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_package_install }}

Auditbeat configuration is managed:
  file.serialize:
    - name: {{ elastic.lookup.config.auditbeat | path_join("auditbeat.yml") }}
    - mode: 644
    - user: root
    - group: {{ elastic.lookup.group.auditbeat }}
    - makedirs: True
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ elastic.auditbeat.config | json }}
