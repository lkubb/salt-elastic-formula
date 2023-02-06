# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".heartbeat.config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_clean }}

Heartbeat is absent:
  pkg.removed:
    - name: {{ elastic.lookup.pkg.heartbeat }}
    - require:
      - sls: {{ sls_config_clean }}
