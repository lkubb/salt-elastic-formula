# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".functionbeat.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_package_install }}

Functionbeat configuration is managed:
  file.serialize:
    - name: {{ elastic.lookup.config.functionbeat | path_join("functionbeat.yml") }}
    - mode: '0644'
    - user: root
    - group: {{ elastic.lookup.group.functionbeat }}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ elastic.functionbeat.config | json }}
