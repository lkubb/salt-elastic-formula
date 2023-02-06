# vim: ft=sls

{#-
    Stops, unconfigures and removes Heartbeat.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
