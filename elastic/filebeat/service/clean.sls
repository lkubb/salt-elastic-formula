# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

Filebeat is dead:
  service.dead:
    - name: {{ elastic.lookup.service.filebeat }}
    - enable: False
