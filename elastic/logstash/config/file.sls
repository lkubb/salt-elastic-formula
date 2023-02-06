# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".logstash.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_package_install }}

Logstash configuration is managed:
  file.serialize:
    - name: {{ elastic.lookup.config.logstash | path_join("logstash.yml") }}
    - mode: '0644'
    - user: root
    - group: {{ elastic.lookup.group.logstash }}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ elastic.logstash.config | json }}
