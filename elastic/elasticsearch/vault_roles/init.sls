# vim: ft=sls

{#-
    Manages Vault database secret engine roles.
    Depends on `elastic.elasticsearch.auth`_ (for managing
    the allowed roles on the connection).
#}

include:
  - .present
