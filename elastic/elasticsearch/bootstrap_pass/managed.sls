# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".elasticsearch.config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_file }}

Ensure bootstrap password is set:
  cmd.run:
    - name: >-
        echo $ELASTICSEARCH_BOOTSTRAP_PASS |
        {{ elastic.lookup.es_tools | path_join("elasticsearch-keystore") }} add -f bootstrap.password
    - env:
      - ELASTICSEARCH_BOOTSTRAP_PASS: {{ elastic.elasticsearch.auth.bootstrap_password }}
    - hide_output: true
    - unless:
      - {{ elastic.lookup.es_tools | path_join("elasticsearch-keystore") }} list | grep bootstrap.password
      - >-
          test $({{ elastic.lookup.es_tools | path_join("elasticsearch-keystore") }} show bootstrap.password)
          = '{{ elastic.elasticsearch.auth.bootstrap_password }}'
    - require:
      - sls: {{ sls_config_file }}
