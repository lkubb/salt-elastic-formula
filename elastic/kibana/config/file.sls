# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".kibana.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

{%- for enc_key in ["xpack.security.encryptionKey", "xpack.reporting.encryptionKey", "xpack.encryptedSavedObjects.encryptionKey"] %}
{%-   if not elastic.kibana.config.get(enc_key) %}
{%-     set current_conf = {} %}
{%-     if salt["file.file_exists"](elastic.lookup.config.kibana | path_join("kibana.yml")) %}
{%-       set current_conf = salt["jinja.import_yaml"](elastic.lookup.config.kibana | path_join("kibana.yml")) %}
{%-     endif %}
{%-     set key = current_conf.get(enc_key) %}
{%-     if not key %}
{%-       set key = salt["random.get_str"](32, punctuation=False) %}
{%-     endif %}
{%-     do elastic.kibana.config.update({enc_key: key}) %}
{%-   endif %}
{%- endfor %}

include:
  - {{ sls_package_install }}

Kibana configuration is managed:
  file.serialize:
    - name: {{ elastic.lookup.config.kibana | path_join("kibana.yml") }}
    - mode: '0644'
    - user: root
    - group: {{ elastic.lookup.group.kibana }}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}
    - dataset: {{ elastic.kibana.config | json }}
