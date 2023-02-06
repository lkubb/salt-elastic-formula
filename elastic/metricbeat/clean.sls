# vim: ft=sls

{#-
    Stops, unconfigures and removes Metricbeat.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
