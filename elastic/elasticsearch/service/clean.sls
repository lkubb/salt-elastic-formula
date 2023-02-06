# vim: ft=sls

{#-
    Stops and disables Elasticsearch at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

Elasticsearch is dead:
  service.dead:
    - name: {{ elastic.lookup.service.elasticsearch }}
    - enable: false
