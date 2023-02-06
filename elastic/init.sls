# vim: ft=sls

{#-
    Installs the Elastic repo and, if configured,
    upgrades Salt's ``cryptography`` module.

    Does not install/configure/start any packages/services.
#}

include:
  - .common
  - .repo
