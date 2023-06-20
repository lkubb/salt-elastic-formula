# vim: ft=sls

{#-
    Installs, configures and starts Kibana, including
    generating client certificates and requesting credentials
    from Vault.
#}

{%- set tplroot = tpldir.split("/")[0] %}

include:
  - .package
  - .config
  - .certs
  - .auth
  - .service
