# -*- coding: utf-8 -*-
# vim: ft=sls

# This state creates valid certificates for Vault
# to access Elasticsearch and should be targeted
# to the minion running Vault.
# This file is a necessary workaround to a current limitation
# in the Vault plugin for Elasticsearch, which requires local
# file paths for certificates and keys.

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

Vault Elasticsearch certificates dir exists:
  file.directory:
    - name: {{ elastic.lookup.vault_certs }}
    - mode: 0755

Vault Elasticsearch client certificate private key is managed:
  x509.private_key_managed:
    - name: {{ elastic.lookup.vault_certs | path_join("vault_elasticsearch_key.pem") }}
    - algo: rsa
    - keysize: 2048
    - new: true
{%- if salt["file.file_exists"](elastic.lookup.vault_certs | path_join("vault_elasticsearch_key.pem")) %}
    - prereq:
      - Vault Elasticsearch client certificate is managed
{%- endif %}
    - mode: '0640'
    - user: root
    - group: vault
    - makedirs: True

Vault Elasticsearch client certificate is managed:
  x509.certificate_managed:
    - name: {{ elastic.lookup.vault_certs | path_join("vault_elasticsearch_cert.pem") }}
    - ca_server: {{ elastic.certs.ca_server or "null" }}
    - signing_policy: {{ elastic.certs.signing_policy or "null" }}
    - signing_cert: {{ elastic.certs.signing_cert or "null" }}
    - signing_private_key: {{ elastic.certs.signing_private_key or "null" }}
    - signing_private_key_passphrase: {{ elastic.certs.signing_private_key_passphrase or "null" }}
    - private_key: {{ elastic.lookup.vault_certs | path_join("vault_elasticsearch_key.pem") }}
    - encoding: pem
    - authorityKeyIdentifier: keyid:always
    - basicConstraints: critical, CA:false
    - subjectKeyIdentifier: hash
    - mode: '0640'
    - user: root
    - group: vault
    - makedirs: True
{%- if not salt["file.file_exists"](elastic.lookup.vault_certs | path_join("vault_elasticsearch_key.pem")) %}
    - require:
      - Vault Elasticsearch client certificate private key is managed
{%- endif %}
