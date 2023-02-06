# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

Heartbeat is dead:
  service.dead:
    - name: {{ elastic.lookup.service.heartbeat }}
    - enable: false
