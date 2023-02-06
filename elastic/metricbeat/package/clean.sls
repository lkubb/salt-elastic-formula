# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".metricbeat.config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_clean }}

Metricbeat is absent:
  pkg.removed:
    - name: {{ elastic.lookup.pkg.metricbeat }}
    - require:
      - sls: {{ sls_config_clean }}
