# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_running = tplroot ~ '.elasticsearch.certs.managed' %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}
{%- set vault_pw = salt["random.get_str"](punctuation=false) %}

include:
  - {{ sls_service_running }}


{%- if "elasticsearch_auth" not in salt["saltutil.list_extmods"]().get("modules", []) %}

Sync custom modules for elasticsearch:
  saltutil.sync_all:
    - refresh: true
    - require_in:
      - Check if bootstrap password was reset
      - Create Vault role in Elasticsearch
{%- endif %}

Check if bootstrap password was reset:
  elasticsearch_auth.check_bootstrap_pass_was_reset:
    - name: elastic
    - auth_password: {{ elastic.elasticsearch.auth.bootstrap_password }}
    - api_url: https://{{ elastic.elasticsearch.vault.es_host }}:{{ elastic | traverse("elasticsearch:config:http.port", 9200) }}
    - require:
      - sls: {{ sls_service_running }}

Create Vault role in Elasticsearch:
  elasticsearch_auth.role_present:
    - name: vault
    - auth_password: {{ elastic.elasticsearch.auth.bootstrap_password }}
    - api_url: https://{{ elastic.elasticsearch.vault.es_host }}:{{ elastic | traverse("elasticsearch:config:http.port", 9200) }}
    - cluster:
      - manage_security
    - onfail:
      - Check if bootstrap password was reset
    - require:
      - sls: {{ sls_service_running }}

Create Vault user in Elasticsearch:
  elasticsearch_auth.user_present:
    - name: vault
    - api_url: https://{{ elastic.elasticsearch.vault.es_host }}:{{ elastic | traverse("elasticsearch:config:http.port", 9200) }}
    - auth_password: {{ elastic.elasticsearch.auth.bootstrap_password }}
    - init_password: {{ vault_pw }}
    - roles:
      - vault
    - require:
      - Create Vault role in Elasticsearch
    - onfail:
      - Check if bootstrap password was reset

{%- if elastic.elasticsearch.auth.roles %}

# This only works until the known password is reset
Ensure ES roles are present during bootstrap:
  elasticsearch_auth.role_present:
    - names:
{%-   for role in elastic.elasticsearch.auth.roles %}
      - {{ role.name }}:
{%-     for var, val in role.items() %}
{%-       if var == "name" %}
{%-         continue %}
{%-       endif %}
        - {{ var }}: {{ val | json }}
{%-     endfor %}
{%-   endfor %}
    - api_url: https://{{ elastic.elasticsearch.vault.es_host }}:{{ elastic | traverse("elasticsearch:config:http.port", 9200) }}
    - auth_password: {{ elastic.elasticsearch.auth.bootstrap_password }}
    - onfail:
      - Check if bootstrap password was reset

Ensure unwanted users are absent during bootstrap:
  elasticsearch_auth.user_absent:
    - names: {{ elastic.elasticsearch.auth.users_absent }}
{%-   if elastic.elasticsearch.auth.root_password or elastic.elasticsearch.auth.root_password_pillar or elastic.elasticsearch.auth.vault_management_role %}

# If we know the new password or have access to a role that allows us to manage roles,
# we can still manage the them
Ensure ES roles are present:
  elasticsearch_auth.role_present:
    - names:
{%-     for role in elastic.elasticsearch.auth.roles %}
      - {{ role.name }}:
{%-       for var, val in role.items() %}
{%-         if var == "name" %}
{%-           continue %}
{%-         endif %}
        - {{ var }}: {{ val | json }}
{%-       endfor %}
{%-     endfor %}
{%-     if elastic.elasticsearch.auth.root_password or elastic.elasticsearch.auth.root_password_pillar %}
    - auth_password: {{ elastic.elasticsearch.auth.password or salt["pillar.get"](elastic.elasticsearch.auth.root_password_pillar) }}
{%-     else %}
{%-       set creds = salt["vault_db.get_creds"](elastic.elasticsearch.auth.management_role, mount=elastic.elasticsearch.vault.database_mount) %}
    - auth_user: {{ creds["username"] }}
    - auth_password: {{ creds["password"] }}
{%-     endif %}
    - api_url: https://{{ elastic.elasticsearch.vault.es_host }}:{{ elastic | traverse("elasticsearch:config:http.port", 9200) }}
    - require:
      - Check if bootstrap password was reset
{%-   endif %}
{%- endif %}

# The Vault Elasticsearch plugin does not currently allow
# importing certificates as PEM, they have to be present
# on the local file system. This needs to be managed separately,
# see `elastic.elasticsearch.vault_setup`.
Initialize Vault database configuration:
  vault_db.connection_present:
    - name: {{ elastic.elasticsearch.vault.connection_name }}
    - mount: {{ elastic.elasticsearch.vault.database_mount }}
    - client_cert: {{ elastic.lookup.vault_certs | path_join("vault_elasticsearch_cert.pem") }}
    - client_key: {{ elastic.lookup.vault_certs | path_join("vault_elasticsearch_key.pem") }}
    - url: https://{{ elastic.elasticsearch.vault.es_host }}:{{ elastic | traverse("elasticsearch:config:http.port", 9200) }}
    - plugin: elasticsearch
    - rotate: true
    - allowed_roles: {{ elastic.elasticsearch.vault_roles | map(attribute="name") | list | json }}
    - username: vault
    - password: {{ vault_pw }}
    - require:
      - Create Vault user in Elasticsearch

{%- if elastic.elasticsearch.auth.root_password or elastic.elasticsearch.auth.root_password_pillar or elastic.elasticsearch.auth.root_password_hash %}

Ensure elastic user password is reset:
  elasticsearch_auth.password_reset:
    - name: elastic
    - old_password: {{ elastic.elasticsearch.auth.bootstrap_password or "null" }}
    - password: {{ elastic.elasticsearch.auth.root_password or "null" }}
    - password_pillar: {{ elastic.elasticsearch.auth.root_password_pillar or "null" }}
    - password_hash: {{ elastic.elasticsearch.auth.root_password_hash or "null" }}
    - onfail:
      - Check if bootstrap password was reset
    - require:
      - Initialize Vault database configuration
{%- endif %}
