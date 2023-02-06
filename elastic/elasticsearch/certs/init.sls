# vim: ft=sls

{#-
    Generates and manages certificates + keys for the HTTP and transport layers,
    including trusted CA certificates for Elasticsearch.
    Note that generally, it's advisable to setup a CA minion. See the
    ``x509`` (``x509_v2``) module docs for details.
    Depends on `elastic.elasticsearch.package`_.
#}

include:
  - .managed
