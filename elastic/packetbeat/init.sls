# vim: ft=sls

{#-
    Installs, configures and starts Packetbeat.
#}

{%- set tplroot = tpldir.split("/")[0] %}

include:
  - .package
  - .config
  - .service
