# vim: ft=sls

{#-
    Installs, configures and starts Functionbeat.
#}

{%- set tplroot = tpldir.split("/")[0] %}

include:
  - {{ tplroot ~ ".common" }}
  - .package
  - .config
  - .service
