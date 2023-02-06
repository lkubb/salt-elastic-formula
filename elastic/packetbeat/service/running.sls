# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".packetbeat.config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_file }}

Packetbeat is running:
  service.running:
    - name: {{ elastic.lookup.service.packetbeat }}
    - enable: true
    - watch:
      - sls: {{ sls_config_file }}
