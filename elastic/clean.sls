# vim: ft=sls

{#-
    *Meta-state*.

    Removes everything Elastic-related:
    includes all clean states.
#}

include:
  - .auditbeat.clean
  - .elasticsearch.clean
  - .filebeat.clean
  - .functionbeat.clean
  - .heartbeat.clean
  - .kibana.clean
  - .logstash.clean
  - .metricbeat.clean
  - .packetbeat.clean
  - .repo.clean
