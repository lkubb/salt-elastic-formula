# vim: ft=sls

{#-
    This should be targeted to your Vault minion(s), not the Elasticsearch one(s).
    Generates and manages ES client certificates for Vault since
    the ES database plugin currently does not allow to
    pass those in via the REST API.
#}

include:
  - .managed
