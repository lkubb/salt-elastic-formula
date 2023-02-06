# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".packetbeat.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_package_install }}

Packetbeat configuration is managed:
  file.serialize:
    - name: {{ elastic.lookup.config.packetbeat | path_join("packetbeat.yml") }}
    - mode: '0644'
    - user: root
    - group: {{ elastic.lookup.group.packetbeat }}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ elastic.packetbeat.config | json }}
