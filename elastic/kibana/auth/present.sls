# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".kibana.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}
{%- set es_creds = {} %}
{%- if not (elastic.kibana.auth.elasticsearch_username and elastic.kibana.auth.elasticsearch_password) %}
{%-   if "kibana_system" in elastic.elasticsearch.vault_roles | map(attribute="name") %}
{%-     set es_creds = salt["vault_db.get_creds"]("kibana_system", mount=elastic.elasticsearch.vault.database_mount) %}
{%-   endif %}
{%- endif %}

include:
  - {{ sls_package_install }}

# This cannot be made stateful since the kibana-keystore command
# does not provide a `show` command. Also, it requires the -x switch
# since it crashes otherwise when stdout is piped
# FIXME: consider moving to plaintext credentials to fix this issue
Ensure elasticsearch username is present in keystore:
  cmd.run:
    - name: echo -n $ES_USERNAME | {{ elastic.lookup.home.kibana | path_join("bin", "kibana-keystore") }} add -fx elasticsearch.username
    - env:
      - ES_USERNAME: {{ es_creds.get("username") or elastic.kibana.auth.elasticsearch_username or "null" }}
    - hide_output: true
    - require:
      - sls: {{ sls_package_install }}

Ensure elasticsearch password is present in keystore:
  cmd.run:
    - name: echo -n $ES_PASSWORD | {{ elastic.lookup.home.kibana | path_join("bin", "kibana-keystore") }} add -fx elasticsearch.password
    - env:
      - ES_PASSWORD: {{ es_creds.get("password") or elastic.kibana.auth.elasticsearch_password or "null" }}
    - hide_output: true
    - require:
      - sls: {{ sls_package_install }}
