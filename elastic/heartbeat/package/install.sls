# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_repo_install = tplroot ~ ".repo.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_repo_install }}

Heartbeat is installed:
  pkg.installed:
    - name: {{ elastic.lookup.pkg.heartbeat }}
    - version: {{ elastic.version or "null" }}
    - require:
      - sls: {{ sls_repo_install }}
