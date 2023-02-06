# vim: ft=sls

{#-
    Stops and disables Kibana at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

Kibana is dead:
  service.dead:
    - name: {{ elastic.lookup.service.kibana }}
    - enable: false
