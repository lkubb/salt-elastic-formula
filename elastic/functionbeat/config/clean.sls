# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".functionbeat.service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Functionbeat configuration is absent:
  file.absent:
    - name: {{ elastic.lookup.config.functionbeat | path_join("functionbeat.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
