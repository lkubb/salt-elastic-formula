# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".elasticsearch.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_package_install }}

Elasticsearch configuration is managed:
  file.serialize:
    - name: {{ elastic.lookup.config.elasticsearch | path_join("elasticsearch.yml") }}
    - mode: '0644'
    - user: root
    - group: {{ elastic.lookup.group.elasticsearch }}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ elastic.elasticsearch.config | json }}

Elasticsearch JVM configuration is managed:
  file.managed:
    - name: {{ elastic.lookup.config.elasticsearch | path_join("jvm.options.d", "salt.options") }}
    - mode: '0644'
    - user: root
    - group: {{ elastic.lookup.group.elasticsearch }}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}
    - contents: {{ elastic.elasticsearch.jvm_config or "" | json }}
