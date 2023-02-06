# vim: ft=sls

{#-
    Enables and (re-)starts Elasticsearch.
    Depends on `elastic.elasticsearch.config`_, `elastic.elasticsearch.certs`_
    and `elastic.elasticsearch.bootstrap_pass`_
#}

include:
  - .running
