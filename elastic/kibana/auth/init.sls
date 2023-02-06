# vim: ft=sls

{#-
    Manages authentication details for Kibana.
    Note that this will always report changes since there is
    no way to read the current configuration.
    Depends on `elastic.kibana.package`_.
#}

include:
  - .present
