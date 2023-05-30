# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".elasticsearch.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

{%- set transport_passphrase = "" %}
{%- set http_passphrase = "" %}
{%- if salt["file.file_exists"](elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore")) %}
{%-   if salt["cmd.run"](
        elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") ~ " list |
        grep xpack.security.transport.ssl.keystore.secure_password", python_shell=true
      ) %}
{%-     set transport_passphrase = salt["cmd.run_stdout"](
          elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore")
          ~ " show xpack.security.transport.ssl.keystore.secure_password"
        ) %}
{%-   endif %}
{%-   if salt["cmd.run"](
        elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") ~ " list |
        grep xpack.security.http.ssl.keystore.secure_password", python_shell=true
      ) %}
{%-     set http_passphrase = salt["cmd.run_stdout"](
          elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") ~ " show xpack.security.http.ssl.keystore.secure_password"
        ) %}
{%-   endif %}
{%- endif %}
{%- if not transport_passphrase %}
{%-   set transport_passphrase = salt["random.get_str"](20, punctuation=False) %}
{%- endif %}
{%- if not http_passphrase %}
{%-   set http_passphrase = salt["random.get_str"](20, punctuation=False) %}
{%- endif %}

include:
  - {{ sls_package_install }}

Elasticsearch HTTP certificate private key is managed:
  x509.private_key_managed:
    - name: {{ elastic.lookup.config.elasticsearch | path_join(elastic | traverse("elasticsearch:config:xpack.security.http.ssl:keystore.path")) }}
    - algo: rsa
    - keysize: 2048
    - new: true
    - encoding: pkcs12
    - passphrase: {{ http_passphrase }}
{%- if salt["file.file_exists"](elastic.lookup.config.elasticsearch | path_join("certs", "http.p12")) %}
    - prereq:
      - Elasticsearch HTTP certificate is managed
{%- endif %}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}

Elasticsearch HTTP certificate is managed:
  x509.certificate_managed:
    - name: {{ elastic.lookup.config.elasticsearch | path_join(elastic | traverse("elasticsearch:config:xpack.security.http.ssl:keystore.path")) }}
    - ca_server: {{ elastic.certs.ca_server or "null" }}
    - signing_policy: {{ elastic.certs.signing_policy or "null" }}
    - signing_cert: {{ elastic.certs.signing_cert or "null" }}
    - signing_private_key: {{ elastic.certs.signing_private_key or "null" }}
    - signing_private_key_passphrase: {{ elastic.certs.signing_private_key_passphrase or "null" }}
    - private_key: {{ elastic.lookup.config.elasticsearch | path_join("certs", "http.p12") }}
    - private_key_passphrase: {{ http_passphrase }}
    - days_remaining: {{ elastic.certs.days_remaining }}
    - days_valid: {{ elastic.certs.days_valid }}
    - encoding: pkcs12
    - authorityKeyIdentifier: keyid:always
    - basicConstraints: critical, CA:false
    - subjectKeyIdentifier: hash
    # required for vault
    - subjectAltName:
      - dns: {{ elastic | traverse("elasticsearch:config:node.name", grains.id) }}
    - CN: {{ elastic | traverse("elasticsearch:config:node.name", grains.id) }}
    - mode: '0660'
    - user: root
    - group: {{ elastic.lookup.group.elasticsearch }}
    - makedirs: true
    - pkcs12_passphrase: {{ http_passphrase }}
    # include intermediate CA certificates, but not the root
    - append_certs: {{ elastic.certs.intermediate | json }}
    - require:
      - sls: {{ sls_package_install }}
{%- if not salt["file.file_exists"](elastic.lookup.config.elasticsearch | path_join("certs", "http.p12")) %}
      - Elasticsearch HTTP certificate private key is managed
{%- endif %}

Elasticsearch transport certificate private key is managed:
  x509.private_key_managed:
    - name: {{ elastic.lookup.config.elasticsearch | path_join(elastic | traverse("elasticsearch:config:xpack.security.transport.ssl:keystore.path")) }}
    - algo: rsa
    - keysize: 2048
    - encoding: pkcs12
    - new: true
    - passphrase: {{ transport_passphrase }}
{%- if salt["file.file_exists"](elastic.lookup.config.elasticsearch | path_join("certs", "transport.p12")) %}
    - prereq:
      - Elasticsearch transport certificate is managed
{%- endif %}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}

Elasticsearch transport certificate is managed:
  x509.certificate_managed:
    - name: {{ elastic.lookup.config.elasticsearch | path_join(elastic | traverse("elasticsearch:config:xpack.security.transport.ssl:keystore.path")) }}
    - ca_server: {{ elastic.certs.ca_server or "null" }}
    - signing_policy: {{ elastic.certs.signing_policy or "null" }}
    - signing_cert: {{ elastic.certs.signing_cert or "null" }}
    - signing_private_key: {{ elastic.certs.signing_private_key or "null" }}
    - signing_private_key_passphrase: {{ elastic.certs.signing_private_key_passphrase or "null" }}
    - private_key: {{ elastic.lookup.config.elasticsearch | path_join("certs", "transport.p12") }}
    - private_key_passphrase: {{ transport_passphrase }}
    - days_remaining: {{ elastic.certs.days_remaining }}
    - days_valid: {{ elastic.certs.days_valid }}
    - encoding: pkcs12
    - authorityKeyIdentifier: keyid:always
    - basicConstraints: critical, CA:false
    - subjectKeyIdentifier: hash
    - subjectAltName:
      - dns: {{ elastic | traverse("elasticsearch:config:node.name", grains.id) }}
    - CN: {{ elastic | traverse("elasticsearch:config:node.name", grains.id) }}
    - mode: '0660'
    - user: root
    - group: {{ elastic.lookup.group.elasticsearch }}
    - makedirs: true
    - pkcs12_passphrase: {{ transport_passphrase }}
    # include intermediate CA certificates, but not the root
    - append_certs: {{ elastic.certs.intermediate | json }}
    - require:
      - sls: {{ sls_package_install }}
{%- if not salt["file.file_exists"](elastic.lookup.config.elasticsearch | path_join("certs", "transport.p12")) %}
      - Elasticsearch transport certificate private key is managed
{%- endif %}

Ensure http pkcs12 password is present in keystore:
  cmd.run:
    - name: >-
        echo $HTTP_PKCS12_PASSPHRASE |
        {{ elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") }} add -f xpack.security.http.ssl.keystore.secure_password
    - hide_output: true
    - env:
      - HTTP_PKCS12_PASSPHRASE: {{ http_passphrase }}
    - unless:
      - {{ elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") }} list | grep xpack.security.http.ssl.keystore.secure_password
      - >-
          test $({{ elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") }}
          show xpack.security.http.ssl.keystore.secure_password) = '{{ http_passphrase }}'
    - require:
      - sls: {{ sls_package_install }}

Ensure transport pkcs12 password is present in keystore:
  cmd.run:
    - name: >-
        echo $TRANSPORT_PKCS12_PASSPHRASE |
        {{ elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") }} add -f xpack.security.transport.ssl.keystore.secure_password
    - hide_output: true
    - env:
      - TRANSPORT_PKCS12_PASSPHRASE: {{ transport_passphrase }}
    - unless:
      - {{ elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") }} list | grep xpack.security.transport.ssl.keystore.secure_password
      - >-
          test $({{ elastic.lookup.home.elasticsearch | path_join("bin", "elasticsearch-keystore") }}
          show xpack.security.transport.ssl.keystore.secure_password) = '{{ transport_passphrase }}'
    - require:
      - sls: {{ sls_package_install }}

Ensure CA certificates are trusted:
  x509.pem_managed:
    - name: {{  elastic.lookup.config.elasticsearch |
                path_join(elastic | traverse("elasticsearch:config:xpack.security.transport.ssl:certificate_authorities")) }}
    # ensure root and intermediate CA certs are in the truststore
    - text: {{ ([elastic.certs.root] + elastic.certs.intermediate) | join("\n") | json }}
    - require:
      - sls: {{ sls_package_install }}
