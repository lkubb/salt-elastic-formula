# vim: ft=sls

{#-
    Removes authentication credentials from the Kibana keystore.
    Depends on `elastic.kibana.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".kibana.service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Ensure elasticsearch username is absent from keystore:
  cmd.run:
    - name: {{ elastic.lookup.home.kibana | path_join("bin", "kibana-keystore") }} remove elasticsearch.username
    - hide_output: true
    - onlyif:
      - {{ elastic.lookup.home.kibana | path_join("bin", "kibana-keystore") }} list | grep elasticsearch.username
    - require:
      - sls: {{ sls_service_clean }}

Ensure elasticsearch password is absent from keystore:
  cmd.run:
    - name: {{ elastic.lookup.home.kibana | path_join("bin", "kibana-keystore") }} remove elasticsearch.password
    - hide_output: true
    - onlyif:
      - {{ elastic.lookup.home.kibana | path_join("bin", "kibana-keystore") }} list | grep elasticsearch.password
    - require:
      - sls: {{ sls_service_clean }}
