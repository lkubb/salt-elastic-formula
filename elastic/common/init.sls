# vim: ft=sls

{#-
    Upgrades ``cryptography``, if configured.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}


{%- if elastic.upgrade_cryptography %}

Install pip for elastic:
  pkg.installed:
    - name: {{ elastic.lookup.pip.pkg }}
    - reload_modules: true

Upgrade cryptography for elastic:
  pip.installed:
    - name: {{ elastic.lookup.pip.cryptography }}<39
    - upgrade: true
    - reload_modules: true
{%- endif %}
