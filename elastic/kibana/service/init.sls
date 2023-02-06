# vim: ft=sls

{#-
    Enables and (re-)starts Kibana.
    Depends on `elastic.kibana.config`_, `elastic.kibana.certs`_
    and `elastic.kibana.auth`_.
#}

include:
  - .running
