# vim: ft=sls

{#-
    Undoes everything in the `elastic.kibana`_ state in reverse.
#}

include:
  - .service.clean
  - .auth.clean
  - .certs.clean
  - .config.clean
  - .package.clean
