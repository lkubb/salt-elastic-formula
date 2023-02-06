# vim: ft=sls

{#-
    Removes managed Vault roles.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_auth_managed = tplroot ~ ".elasticsearch.auth.managed" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

{%- for role in elastic.elasticsearch.vault_roles %}

Vault Elasticsearch role {{ role.name }} is present:
  vault_db.role_absent:
    - name: {{ role.name }}
    - mount: {{ elastic.elasticsearch.vault.database_mount }}
{%- endfor %}
