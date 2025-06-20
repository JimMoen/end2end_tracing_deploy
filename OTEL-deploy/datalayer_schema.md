## Database

```bash
dlsql -u admin -p public
```

```sql
> create database mydb
Query OK, 0 rows affected. (0.001 sec)
```


## Schemas

将所有的 trace 事件存储到以下 2 个表中：

__client_events__:

```sql
CREATE TABLE IF NOT EXISTS `client_events` (
    time TIMESTAMP(9) NOT NULL,
    client_clientid STRING NOT NULL,
    trace_id STRING NOT NULL,
    span_id STRING NOT NULL,
    service_name STRING,
    span_name STRING,
    span_kind STRING,
    end_time_unix_nano INT64,
    duration_nano INT64,
    cluster_id STRING NOT NULL,
    attributes STRING,
    parent_span_id STRING,
    client_connect_authn_result STRING,
    authz_publish_result STRING,
    client_subscribe_topics STRING,
    authz_subscribe_result STRING,
    service_instance_id STRING,
    client_unsubscribe_topics STRING,
    client_subscribe_sub_opts STRING,
    otel_status_code STRING,
    otel_status_description STRING,
    timestamp key(time)
) PARTITION BY HASH (client_clientid, cluster_id, span_name) PARTITIONS 1
ENGINE=TimeSeries with (ttl='14d');
```

```sql
mydb> show create table client_events;
+---------------+-------------------------------------------------------------------------------+
| table         | created_table                                                                 |
+---------------+-------------------------------------------------------------------------------+
| client_events | CREATE TABLE `client_events` (                                                |
|               |   `time` TIMESTAMP(9) NOT NULL,                                               |
|               |   `client_clientid` STRING NOT NULL,                                          |
|               |   `cluster_id` STRING NOT NULL,                                               |
|               |   `span_name` STRING NOT NULL,                                                |
|               |   `trace_id` STRING NOT NULL,                                                 |
|               |   `span_id` STRING NOT NULL,                                                  |
|               |   `service_name` STRING,                                                      |
|               |   `span_kind` STRING,                                                         |
|               |   `end_time_unix_nano` INT64,                                                 |
|               |   `duration_nano` INT64,                                                      |
|               |   `attributes` STRING,                                                        |
|               |   `parent_span_id` STRING,                                                    |
|               |   `client_connect_authn_result` STRING,                                       |
|               |   `authz_publish_result` STRING,                                              |
|               |   `client_subscribe_topics` STRING,                                           |
|               |   `authz_subscribe_result` STRING,                                            |
|               |   `service_instance_id` STRING,                                               |
|               |   `client_unsubscribe_topics` STRING,                                         |
|               |   `client_subscribe_sub_opts` STRING,                                         |
|               |   `otel_status_code` STRING,                                                  |
|               |   `otel_status_description` STRING,                                           |
|               |   TIMESTAMP KEY(`time`)                                                       |
|               | )                                                                             |
|               | PARTITION BY HASH (`client_clientid`, `cluster_id`, `span_name`) PARTITIONS 1 |
|               | ENGINE=TimeSeries                                                             |
|               | WITH (                                                                        |
|               |   STORAGE_TYPE='LOCAL',                                                       |
|               |   TTL='14d'                                                                   |
|               | )                                                                             |
+---------------+-------------------------------------------------------------------------------+
1 row in set (0.003 sec)
```

__message_events__:

```sql
CREATE TABLE IF NOT EXISTS `message_events` (
    time TIMESTAMP(9) NOT NULL,
    client_clientid STRING NOT NULL,
    trace_id STRING NOT NULL,
    span_id STRING NOT NULL,
    service_name STRING,
    span_name STRING,
    span_kind STRING,
    end_time_unix_nano INT64,
    duration_nano INT64,
    cluster_id STRING NOT NULL,
    attributes STRING,
    parent_span_id STRING,
    message_from STRING,
    message_topic STRING,
    message_msgid STRING,
    service_instance_id STRING,
    otel_status_code STRING,
    otel_status_description STRING,
    timestamp key(time)
) PARTITION BY HASH (client_clientid, cluster_id, span_name) PARTITIONS 1
ENGINE=TimeSeries with (ttl='14d');
```

```sql
mydb> show create table message_events;
+----------------+-------------------------------------------------------------------------------+
| table          | created_table                                                                 |
+----------------+-------------------------------------------------------------------------------+
| message_events | CREATE TABLE `message_events` (                                               |
|                |   `time` TIMESTAMP(9) NOT NULL,                                               |
|                |   `client_clientid` STRING NOT NULL,                                          |
|                |   `cluster_id` STRING NOT NULL,                                               |
|                |   `span_name` STRING NOT NULL,                                                |
|                |   `trace_id` STRING NOT NULL,                                                 |
|                |   `span_id` STRING NOT NULL,                                                  |
|                |   `service_name` STRING,                                                      |
|                |   `span_kind` STRING,                                                         |
|                |   `end_time_unix_nano` INT64,                                                 |
|                |   `duration_nano` INT64,                                                      |
|                |   `attributes` STRING,                                                        |
|                |   `parent_span_id` STRING,                                                    |
|                |   `message_from` STRING,                                                      |
|                |   `message_topic` STRING,                                                     |
|                |   `message_msgid` STRING,                                                     |
|                |   `service_instance_id` STRING,                                               |
|                |   `otel_status_code` STRING,                                                  |
|                |   `otel_status_description` STRING,                                           |
|                |   TIMESTAMP KEY(`time`)                                                       |
|                | )                                                                             |
|                | PARTITION BY HASH (`client_clientid`, `cluster_id`, `span_name`) PARTITIONS 1 |
|                | ENGINE=TimeSeries                                                             |
|                | WITH (                                                                        |
|                |   STORAGE_TYPE='LOCAL',                                                       |
|                |   TTL='14d'                                                                   |
|                | )                                                                             |
+----------------+-------------------------------------------------------------------------------+
1 row in set (0.001 sec)
```


__spans__:

```sql
CREATE TABLE IF NOT EXISTS spans (
    time TIMESTAMP(9) NOT NULL,
    span_id STRING NOT NULL,
    trace_id STRING NOT NULL,
    service_name STRING NOT NULL,
    span_name STRING,
    span_kind STRING,
    end_time_unix_nano INT64,
    duration_nano INT64,
    attributes STRING,
    parent_span_id STRING,
    trace_state STRING,
    dropped_events_count INT64,
    dropped_links_count INT64,
    dropped_attributes_count INT64,
    otel_status_code STRING,
    otel_status_description STRING,
    span_mytype STRING,
    timestamp key (time)
) PARTITION BY HASH(service_name) PARTITIONS 1
ENGINE=TimeSeries with (ttl='14d');
```


```sql

mydb> show create table spans;
+-------+-------------------------------------------------+
| table | created_table                                   |
+-------+-------------------------------------------------+
| spans | CREATE TABLE `spans` (                          |
|       |   `time` TIMESTAMP(9) NOT NULL,                 |
|       |   `service_name` STRING NOT NULL,               |
|       |   `span_id` STRING NOT NULL,                    |
|       |   `trace_id` STRING NOT NULL,                   |
|       |   `span_name` STRING,                           |
|       |   `span_kind` STRING,                           |
|       |   `end_time_unix_nano` INT64,                   |
|       |   `duration_nano` INT64,                        |
|       |   `attributes` STRING,                          |
|       |   `parent_span_id` STRING,                      |
|       |   `trace_state` STRING,                         |
|       |   `dropped_events_count` INT64,                 |
|       |   `dropped_links_count` INT64,                  |
|       |   `dropped_attributes_count` INT64,             |
|       |   `otel_status_code` STRING,                    |
|       |   `otel_status_description` STRING,             |
|       |   `span_mytype` STRING,                         |
|       |   TIMESTAMP KEY(`time`)                         |
|       | )                                               |
|       | PARTITION BY HASH (`service_name`) PARTITIONS 1 |
|       | ENGINE=TimeSeries                               |
|       | WITH (                                          |
|       |   STORAGE_TYPE='LOCAL',                         |
|       |   TTL='14d'                                     |
|       | )                                               |
+-------+-------------------------------------------------+
1 row in set (0.001 sec)
```
