# vim: ft=sls

{#-
    Removes generated Kibana certificates and keys.
    Depends on `elastic.kibana.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".kibana.service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_service_clean }}

Kibana certificates are absent:
  file.absent:
    - names:
      - {{ elastic | traverse("kibana:config:server.ssl:key") }}
      - {{ elastic | traverse("kibana:config:server.ssl:certificate") }}
      - {{ elastic | traverse("kibana:config:server.ssl:certificateAuthorities") }}
    - require:
      - sls: {{ sls_service_clean }}

Ensure Kibana server pkcs12 password is absent from keystore:
  cmd.run:
    - name: {{ elastic.lookup.home.kibana | path_join("bin", "kibana-keystore") }} remove server.ssl.keyPassphrase
    - hide_output: true
    - onlyif:
      - {{ elastic.lookup.home.kibana | path_join("bin", "kibana-keystore") }} list | grep server.ssl.keyPassphrase
    - require:
      - sls: {{ sls_service_clean }}
