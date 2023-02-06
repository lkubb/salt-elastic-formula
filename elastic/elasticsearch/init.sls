# vim: ft=sls

{#-
    *Meta-state*.
    Manages the lifecycle of an Elasticsearch node/cluster
    with integration to the Vault database secret engine.

    Includes all states for ES, with the exception of
    `elastic.elasticsearch.vault_setup`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ tplroot ~ ".common" }}
  - .package
  - .config
  - .certs
  - .bootstrap_pass
  - .service
{%- if elastic.elasticsearch.vault.es_host %}
  - .auth
  - .vault_roles
{%- endif %}
