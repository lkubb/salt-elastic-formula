# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".metricbeat.service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Metricbeat configuration is absent:
  file.absent:
    - name: {{ elastic.lookup.config.metricbeat | path_join("metricbeat.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
