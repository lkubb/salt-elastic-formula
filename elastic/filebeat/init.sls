# vim: ft=sls

{#-
    Installs, configures and starts Filebeat.
#}

{%- set tplroot = tpldir.split("/")[0] %}

include:
  - .package
  - .config
  - .service
