# vim: ft=sls

{#-
    Ensures a known bootstrap password is set in order to
    be able to manage the initial configuration non-interactively.
    Depends on `elastic.elasticsearch.config`_.
#}

include:
  - .managed
