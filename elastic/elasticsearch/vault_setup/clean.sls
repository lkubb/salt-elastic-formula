# vim: ft=sls

{#-
    Removes generated certificate and key from the Vault server's filesystem.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

Vault Elasticsearch certificate is absent:
  file.absent:
    - names:
      - {{ elastic.lookup.vault_certs | path_join("vault_elasticsearch_key.pem") }}
      - {{ elastic.lookup.vault_certs | path_join("vault_elasticsearch_cert.pem") }}
