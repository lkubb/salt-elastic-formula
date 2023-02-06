# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".heartbeat.config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_file }}

Heartbeat is running:
  service.running:
    - name: {{ elastic.lookup.service.heartbeat }}
    - enable: true
    - watch:
      - sls: {{ sls_config_file }}
