# vim: ft=sls

{#-
    Ensures no bootstrap password is set.
    Depends on `elastic.elasticsearch.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".elasticsearch.service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Ensure bootstrap password is unset:
  cmd.run:
    - name: {{ elastic.lookup.es_tools | path_join("elasticsearch-keystore") }} remove bootstrap.password
    - hide_output: true
    - onlyif:
      - {{ elastic.lookup.es_tools | path_join("elasticsearch-keystore") }} list | grep bootstrap.password
