# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.elasticsearch.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Elasticsearch certificates are absent:
  file.absent:
    - names:
      - {{ elastic.lookup.config.elasticsearch | path_join(elastic | traverse("elasticsearch:config:xpack.security.http.ssl:keystore.path")) }}
      - {{ elastic.lookup.config.elasticsearch | path_join(elastic | traverse("elasticsearch:config:xpack.security.http.transport:keystore.path")) }}
      - {{ elastic.lookup.config.elasticsearch | path_join(elastic | traverse("elasticsearch:config:xpack.security.http.transport:certificate_authorities")) }}

Ensure http pkcs12 password is absent from keystore:
  cmd.run:
    - name: {{ elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") }} remove xpack.security.http.ssl.keystore.secure_password
    - hide_output: true
    - onlyif:
      - {{ elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") }} list | grep xpack.security.http.ssl.keystore.secure_password

Ensure transport pkcs12 password is absent from keystore:
  cmd.run:
    - name: {{ elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") }} remove xpack.security.transport.ssl.keystore.secure_password
    - hide_output: true
    - onlyif:
      - {{ elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") }} list | grep xpack.security.transport.ssl.keystore.secure_password
