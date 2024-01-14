# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".kibana.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

include:
  - {{ sls_package_install }}

Kibana server certificate private key is managed:
  x509.private_key_managed:
    - name: {{ elastic | traverse("kibana:config:server.ssl:key") }}
    - algo: rsa
    - keysize: 2048
    - new: true
    - mode: '0660'
    - user: root
    - group: {{ elastic.lookup.group.kibana }}
{%- if salt["file.file_exists"](elastic | traverse("kibana:config:server.ssl:certificate")) %}
    - prereq:
      - Kibana server certificate is managed
{%- endif %}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}

Kibana server certificate is managed:
  x509.certificate_managed:
    - name: {{ elastic | traverse("kibana:config:server.ssl:certificate") }}
    - ca_server: {{ elastic.certs.ca_server or "null" }}
    - signing_policy: {{ elastic.certs.signing_policy or "null" }}
    - signing_cert: {{ elastic.certs.signing_cert or "null" }}
    - signing_private_key: {{ elastic.certs.signing_private_key or "null" }}
    - signing_private_key_passphrase: {{ elastic.certs.signing_private_key_passphrase or "null" }}
    - private_key: {{ elastic | traverse("kibana:config:server.ssl:key") }}
    - days_remaining: {{ elastic.certs.days_remaining }}
    - days_valid: {{ elastic.certs.days_valid }}
    - authorityKeyIdentifier: keyid:always
    - basicConstraints: critical, CA:false
    - subjectKeyIdentifier: hash
    # required for vault
    - subjectAltName:
      - dns: {{ elastic | traverse("elasticsearch:config:node.name", grains.id) }}
    - CN: {{ elastic | traverse("elasticsearch:config:node.name", grains.id) }}
    - mode: '0660'
    - user: root
    - group: {{ elastic.lookup.group.kibana }}
    - makedirs: true
    # include intermediate CA certificates, but not the root
    - append_certs: {{ elastic.certs.intermediate | json }}
    - require:
      - sls: {{ sls_package_install }}
{%- if not salt["file.file_exists"](elastic | traverse("kibana:config:server.ssl:certificate")) %}
      - Kibana server certificate private key is managed
{%- endif %}

Ensure CA certificates are trusted for Kibana:
  x509.pem_managed:
    - name: {{ elastic | traverse("kibana:config:server.ssl:certificateAuthorities") }}
    # ensure root and intermediate CA certs are in the truststore
    - text: {{ ([elastic.certs.root] + elastic.certs.intermediate) | join("\n") | json }}
    - require:
      - sls: {{ sls_package_install }}
