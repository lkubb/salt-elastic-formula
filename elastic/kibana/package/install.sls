# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_repo_install = tplroot ~ ".repo.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_repo_install }}


{%- if grains["os"] == "RedHat" and grains["osmajorrelease"] == 9 %}

# Elasticsearch RPM packages are currently signed with a deprecated algorithm
# somewhere in the chain (SHA1). This fails on RHEL 9 (+ clones)

Ensure crypto policies scripts are present:
  pkg.installed:
    - name: crypto-policies-scripts

Temporarily allow signatures using SHA1:
  cmd.run:
    - name: update-crypto-policies --set DEFAULT:SHA1
    - require:
      - pkg: crypto-policies-scripts
{%- endif %}

Kibana is installed:
  pkg.installed:
    - name: {{ elastic.lookup.pkg.kibana }}
    - version: {{ elastic.version or "null" }}
    - require:
      - sls: {{ sls_repo_install }}

{%- if grains["os"] == "RedHat" and grains["osmajorrelease"] == 9 %}

Disallow signatures using SHA1 again:
  cmd.run:
    - name: update-crypto-policies --set DEFAULT
{%- endif %}
