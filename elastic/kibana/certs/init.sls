# vim: ft=sls

{#-
    Generates client certificates and ensures
    the CA is trusted by Kibana.
    Depends on `elastic.kibana.package`_.
#}

include:
  - .managed
