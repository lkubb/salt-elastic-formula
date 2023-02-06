# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}

{%- if grains["os"] in ["Debian", "Ubuntu"] %}

Ensure Elastic APT repository can be managed:
  pkg.installed:
    - pkgs:
      - python3-apt                   # required by Salt
{%- endif %}

{%- for reponame, enabled in elastic.lookup.enablerepo.items() %}
{%-   if enabled %}

Elastic {{ reponame }} repository is available:
  pkgrepo.managed:
{%-     for conf, val in elastic.lookup.repos[reponame].items() %}
    - {{ conf }}: {{ val.format(major=elastic._major) if val is string else val }}
{%-     endfor %}
{%-     if elastic.lookup.pkg_manager in ["dnf", "yum", "zypper"] %}
    - enabled: 1
{%-     endif %}

{%-   else %}

Elastic {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-     for conf in ["name", "ppa", "ppa_auth", "keyid", "keyid_ppa", "copr"] %}
{%-       if conf in elastic.lookup.repos[reponame] %}
    - {{ conf }}: {{ elastic.lookup.repos[reponame][conf].format(major=elastic._major) }}
{%-       endif %}
{%-     endfor %}
{%-   endif %}
{%- endfor %}
