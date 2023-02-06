# vim: ft=sls

{#-
    Stops, unconfigures and removes Packetbeat.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
