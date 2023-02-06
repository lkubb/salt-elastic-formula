# vim: ft=sls

{#-
    Stops, unconfigures and removes Filebeat.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
