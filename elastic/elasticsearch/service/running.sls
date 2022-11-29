# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.elasticsearch.config.file' %}
{%- set sls_certs_managed = tplroot ~ '.elasticsearch.certs.managed' %}
{%- set sls_bootstrap_pass_managed = tplroot ~ '.elasticsearch.bootstrap_pass.managed' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_config_file }}
  - {{ sls_certs_managed }}
  - {{ sls_bootstrap_pass_managed }}

Elasticsearch is running:
  service.running:
    - name: {{ elastic.lookup.service.elasticsearch }}
    - enable: True
    - require:
      - sls: {{ sls_bootstrap_pass_managed }}
    - watch:
      - sls: {{ sls_config_file }}
      - sls: {{ sls_certs_managed }}

{%- if grains["os_family"] == "RedHat" %}

Elasticsearch service is known:
  firewalld.service:
    - name: elasticsearch
    - ports:
      - {{ elastic | traverse("elasticsearch:config:http.port", 9200) }}/tcp
      - {{ elastic | traverse("elasticsearch:config:transport.port", 9300) }}/tcp
    - require:
      - Elasticsearch is running

Elasticsearch ports are open:
  firewalld.present:
    - name: public
    - services:
      - elasticsearch
    - require:
      - Elasticsearch service is known
{%- endif %}
