# vim: ft=sls

{#-
    Removes the Vault database connection, only if
    ``remove_all_data_for_sure`` is true.
    Depends on `elastic.elasticsearch.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".elasticsearch.service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

# Cleaning most of this up should be impossible, unless the
# bootstrap password was not changed or the new password
# specified in plaintext.

{%- if elastic.remove_all_data_for_sure %}

Vault database configuration is absent:
  vault_db.connection_absent:
    - name: {{ elastic.elasticsearch.vault.connection_name }}
    - mount: {{ elastic.elasticsearch.vault.database_mount }}
    - require:
      - sls: {{ sls_service_clean }}
{%- endif %}
