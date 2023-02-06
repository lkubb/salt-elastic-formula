# vim: ft=sls

{#-
    Stops, unconfigures and removes Logstash.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
