# vim: ft=sls

{#-
    Installs, configures and starts Auditbeat.
#}

{%- set tplroot = tpldir.split("/")[0] %}

include:
  - .package
  - .config
  - .service
