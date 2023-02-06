# vim: ft=sls

{#-
    Installs, configures and starts Metricbeat.
#}

{%- set tplroot = tpldir.split("/")[0] %}

include:
  - {{ tplroot ~ ".common" }}
  - .package
  - .config
  - .service
