# vim: ft=yaml
---
elastic:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    enablerepo:
      stable: true
    config:
      auditbeat: /etc/auditbeat
      elasticsearch: /etc/elasticsearch
      filebeat: /etc/filebeat
      functionbeat: /etc/functionbeat
      heartbeat: /etc/heartbeat
      kibana: /etc/kibana
      logstash: /etc/logstash
      metricbeat: /etc/metricbeat
      packetbeat: /etc/packetbeat
    es_tools: /usr/share/elasticsearch/bin
    group:
      auditbeat: auditbeat
      elasticsearch: elasticsearch
      filebeat: filebeat
      functionbeat: functionbeat
      heartbeat: heartbeat
      kibana: kibana
      logstash: logstash
      metricbeat: metricbeat
      packetbeat: packetbeat
    home:
      elasticsearch: /usr/share/elasticsearch
      kibana: /usr/share/kibana
    pkg:
      auditbeat: auditbeat
      elasticsearch: elasticsearch
      filebeat: filebeat
      functionbeat: functionbeat
      heartbeat: heartbeat
      kibana: kibana
      logstash: logstash
      metricbeat: metricbeat
      packetbeat: packetbeat
    service:
      auditbeat: auditbeat
      elasticsearch: elasticsearch
      filebeat: filebeat
      functionbeat: functionbeat
      heartbeat: heartbeat
      kibana: kibana
      logstash: logstash
      metricbeat: metricbeat
      packetbeat: packetbeat
    vault_certs: /opt/vault/tls
  auditbeat:
    config: {}
  certs:
    ca_server: null
    days_remaining: null
    days_valid: null
    intermediate: []
    root: ''
    signing_cert: null
    signing_policy: null
    signing_private_key: null
    signing_private_key_passphrase: null
  elasticsearch:
    auth:
      bootstrap_password: bo0t_57R4P
      roles: []
      root_password: null
      root_password_hash: null
      root_password_pillar: null
      users_absent:
        - kibana
        - kibana_system
        - logstash_system
        - beats_system
        - apm_system
        - remote_monitoring_user
      vault_management_role: null
    certs:
      cn: null
      san: null
    config:
      cluster.initial_master_nodes: []
      cluster.name: elasticsearch
      http.port: 9200
      network.host: 0.0.0.0
      node.name: ''
      path.data: /var/lib/elasticsearch
      path.logs: /var/log/elasticsearch
      transport.port: 9300
      xpack.security.autoconfiguration.enabled: false
      xpack.security.enabled: true
      xpack.security.http.ssl:
        enabled: true
        keystore.path: certs/http.p12
      xpack.security.transport.ssl:
        certificate_authorities: certs/trust.pem
        enabled: true
        keystore.path: certs/transport.p12
        verification_mode: certificate
    jvm_config: []
    vault:
      connection_name: elasticsearch
      database_mount: database
      es_host: null
    vault_roles:
      - name: kibana_system
        roles:
          - kibana_system
      - name: logstash_system
        roles:
          - logstash_system
      - name: beats_system
        roles:
          - beats_system
      - name: apm_system
        roles:
          - apm_system
      - name: remote_monitoring_user
        roles:
          - remote_monitoring_collector
          - remote_monitoring_agent
  filebeat:
    config: {}
  functionbeat:
    config: {}
  heartbeat:
    config: {}
  kibana:
    auth:
      elasticsearch_password: null
      elasticsearch_username: kibana_system
    certs:
      cn: null
      san: null
    config:
      elasticsearch.hosts:
        - http://localhost:9200
      elasticsearch.ssl.certificateAuthorities: /etc/kibana/certs/trust.pem
      logging:
        appenders:
          journal:
            layout:
              pattern: '[%date] [%level] [%logger] [%meta] %message'
              type: pattern
            type: console
      server.host: 0.0.0.0
      server.port: 5601
      server.ssl:
        certificate: /etc/kibana/certs/http.crt
        certificateAuthorities: /etc/kibana/certs/trust.pem
        enabled: true
        key: /etc/kibana/certs/http.key
        supportedProtocols:
          - TLSv1.3
      telemetry.optIn: false
  logstash:
    config: {}
  manage_firewalld: false
  metricbeat:
    config: {}
  packetbeat:
    config: {}
  remove_all_data_for_sure: false
  version: null
  version_major: '8'

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://elastic/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   elastic-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      elastic-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
