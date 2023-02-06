# vim: ft=sls

{#-
    Stops, unconfigures and removes Auditbeat.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
