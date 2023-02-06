# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".logstash.config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_clean }}

Logstash is absent:
  pkg.removed:
    - name: {{ elastic.lookup.pkg.logstash }}
    - require:
      - sls: {{ sls_config_clean }}
