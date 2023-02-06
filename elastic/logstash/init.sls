# vim: ft=sls

{#-
    Installs, configures and starts Filebeat.
#}

{%- set tplroot = tpldir.split("/")[0] %}

include:
  - {{ tplroot ~ ".common" }}
  - .package
  - .config
  - .service
