# vim: ft=sls

{#-
    Takes care of managing ES users and groups and
    managing the Vault database secret engine connection.
    Also, optionally resets the bootstrap password.
    Depends on `elastic.elasticsearch.service`_.
#}

include:
  - .managed
