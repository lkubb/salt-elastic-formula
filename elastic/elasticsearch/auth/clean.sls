# Cleaning most of this up should be impossible, unless the
# bootstrap password was not changed or the new password
# specified in plaintext.

{%- if elastic.remove_all_data_for_sure %}

Vault database configuration is absent:
  vault_db.connection_absent:
    - name: {{ elastic.elasticsearch.vault.connection_name }}
    - mount: {{ elastic.elasticsearch.vault.database_mount }}
{%- endif %}
