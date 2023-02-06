# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".packetbeat.service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Packetbeat configuration is absent:
  file.absent:
    - name: {{ elastic.lookup.config.packetbeat | path_join("packetbeat.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
