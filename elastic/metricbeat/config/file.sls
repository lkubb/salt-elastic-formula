# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.metricbeat.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_package_install }}

Metricbeat configuration is managed:
  file.serialize:
    - name: {{ elastic.lookup.config.metricbeat | path_join("metricbeat.yml") }}
    - mode: 644
    - user: root
    - group: {{ elastic.lookup.group.metricbeat }}
    - makedirs: True
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ elastic.metricbeat.config | json }}
