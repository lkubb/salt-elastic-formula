# vim: ft=sls

{#-
    Stops, unconfigures and removes Functionbeat.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
