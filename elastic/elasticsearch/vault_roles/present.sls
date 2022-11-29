# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_auth_managed = tplroot ~ ".elasticsearch.auth.managed" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_auth_managed }}

# ES plugin does not support static roles as usual. It depends
# on the root key of `creation_statements`:
# For dynamic roles, use `elasticsearch_role_definition` and specify
# parameters for https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-put-role.html
# For static roles, use `elasticsearch_roles` and pass a list of roles
# present in ES only.
{%- for role in elastic.elasticsearch.vault_roles %}

Vault Elasticsearch role {{ role.name }} is present:
  vault_db.role_present:
    - name: {{ role.name }}
    - mount: {{ elastic.elasticsearch.vault.database_mount }}
    - connection: {{ elastic.elasticsearch.vault.connection_name }}
    - creation_statements:
{%-   if "roles" in role %}
        - '{{ {"elasticsearch_roles": role.roles} | json }}'
{%-   else %}
        - '{{ {"elasticsearch_role_definition": role.definition} | json }}'
{%-   endif %}
    - default_ttl: {{ role.get("default_ttl") or "null" }}
    - max_ttl: {{ role.get("max_ttl") or "null" }}
    - require:
      - Initialize Vault database configuration
{%- endfor %}
