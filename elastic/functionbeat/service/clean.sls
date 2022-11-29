# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

Functionbeat is dead:
  service.dead:
    - name: {{ elastic.lookup.service.functionbeat }}
    - enable: False
