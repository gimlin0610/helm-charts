# Pick up all the auto-generated input config files, one for each file
# specified in the FILES_TO_COLLECT environment variable.
@include files/*

<system>
  log_level info
</system>

# All the auto-generated files should use the tag "file.<filename>".
<source>
  @type systemd
  path /var/log/journal
  <storage>
    @type local
    persistent true
    path /var/log/journal.pos
  </storage>
  tag systemd
  read_from_head true
</source>

<filter **>
  @type systemd_entry
#  field_map {"MESSAGE": "log", "_PID": ["process", "pid"], "_CMDLINE": "process", "_COMM": "cmd"}
#  field_map_strict false
  fields_lowercase true
  fields_strip_underscores true
</filter>

#<match **>
#  @type stdout
#</match>

<match **>
  @type copy
  <store>
   @type elasticsearch
   host {{.Values.elk_elasticsearch_endpoint_host_internal}}
   port {{.Values.elk_elasticsearch_http_port}}
   user {{.Values.elk_elasticsearch_data_user}}
   password {{.Values.elk_elasticsearch_data_password}}
   index_name systemd
   type_name fluentd
   logstash_prefix systemd
   logstash_format true
   time_as_integer false
   @log_level info
   slow_flush_log_threshold 40.0
   request_timeout 60s
   include_tag_key true
   resurrect_after 120
   reconnect_on_error true
   <buffer>
     flush_at_shutdown true
     flush_thread_interval 5
     overflow_action block
     retry_forever true
     retry_wait 2s
     flush_thread_count 4
     flush_interval 3s
   </buffer>
  </store>
{{- if .Values.scaleout.enabled }}
  <store>
   @type elasticsearch_dynamic
   host {{.Values.elk_elasticsearch_endpoint_host_scaleout}}.{{.Values.cluster_region}}.{{.Values.domain}}
   port {{.Values.elk_elasticsearch_ssl_port}}
   user {{.Values.elk_elasticsearch_data_user}}
   password {{.Values.elk_elasticsearch_data_password}}
   scheme https
   ssl_verify false
   ssl_version TLSv1_2
   index_name systemd
   type_name fluentd
   logstash_prefix systemd
   logstash_format true
   time_as_integer false
   @log_level info
   slow_flush_log_threshold 50.0
   request_timeout 60s
   include_tag_key true
   resurrect_after 120
   reconnect_on_error true
   <buffer>
     flush_at_shutdown true
     flush_thread_interval 5
     overflow_action block
     retry_forever true
     retry_wait 2s
     flush_thread_count 4
     flush_interval 3s
   </buffer>
  </store>
{{ end -}}
# second is missing, it it is only deployed to one elk cluster
 </match>
