# vim: ft=sls

{#-
    Installs, configures and starts Heartbeat.
#}

{%- set tplroot = tpldir.split("/")[0] %}

include:
  - .package
  - .config
  - .service
