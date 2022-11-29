# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as elastic with context %}


{%- if elastic.lookup.pkg_manager not in ['apt', 'dnf', 'yum', 'zypper'] %}
{%-   if salt['state.sls_exists'](slsdotpath ~ '.' ~ elastic.lookup.pkg_manager ~ '.clean') %}

include:
  - {{ slsdotpath ~ '.' ~ elastic.lookup.pkg_manager ~ '.clean' }}
{%-   endif %}

{%- else %}
{%-   for reponame, enabled in elastic.lookup.enablerepo.items() %}
{%-     if enabled %}

Elastic {{ reponame }} repository is absent:
  pkgrepo.absent:
{%-       for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-         if conf in elastic.lookup.repos[reponame] %}
    - {{ conf }}: {{ elastic.lookup.repos[reponame][conf].format(major=elastic._major) }}
{%-         endif %}
{%-       endfor %}
{%-     endif %}
{%-   endfor %}
{%- endif %}
