# vim: ft=sls

{#-
    Removes Elasticsearch.
    Depends on `elastic.elasticsearch.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".elasticsearch.config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_clean }}

Elasticsearch is absent:
  pkg.removed:
    - name: {{ elastic.lookup.pkg.elasticsearch }}
    - require:
      - sls: {{ sls_config_clean }}
