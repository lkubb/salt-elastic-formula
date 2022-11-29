# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_auth_present = tplroot ~ '.kibana.auth.present' %}
{%- set sls_certs_managed = tplroot ~ '.kibana.certs.managed' %}
{%- set sls_config_file = tplroot ~ '.kibana.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_auth_present }}

Kibana is running:
  service.running:
    - name: {{ elastic.lookup.service.kibana }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
      - sls: {{ sls_auth_present }}
      - sls: {{ sls_certs_managed }}

{%- if grains["os_family"] == "RedHat" %}

Kibana service is known:
  firewalld.service:
    - name: kibana
    - ports:
      - {{ elastic | traverse("kibana:config:server.port", 5601) }}/tcp
    - require:
      - Kibana is running

Kibana ports are open:
  firewalld.present:
    - name: public
    - services:
      - kibana
    - require:
      - Kibana service is known
{%- endif %}
