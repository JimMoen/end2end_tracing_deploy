Schemas
创建数据库
```bash
$ dlsql -u admin -p public
```

```sql
create database mydb
```

```sql
use mydb
```

将所有的 trace 事件存储到以下 2 个表中：

__client_events__:

```sql
CREATE TABLE `client_events` (
`time` TIMESTAMP(9) NOT NULL,
`client_clientid` STRING NOT NULL,
`cluster_id` STRING NOT NULL,
`span_name` STRING NOT NULL,
`trace_id` STRING NOT NULL,
`span_id` STRING NOT NULL,
`service_name` STRING,
`span_kind` STRING,
`end_time_unix_nano` INT64,
`duration_nano` INT64,
`attributes` STRING,
`parent_span_id` STRING,
`client_connect_authn_result` STRING,
`authz_publish_result` STRING,
`client_subscribe_topics` STRING,
`authz_subscribe_result` STRING,
`service_instance_id` STRING,
`client_unsubscribe_topics` STRING,
`client_subscribe_sub_opts` STRING,
`otel_status_code` STRING,
`otel_status_description` STRING,
timestamp key(`time`)
)
PARTITION BY HASH (`client_clientid`, `cluster_id`, `span_name`) PARTITIONS 1
ENGINE=TimeSeries
with (
TTL='30d',
STORAGE_TYPE='LOCAL'
)
```

```sql
show create table client_events
+---------------+-------------------------------------------------------------------------------+
| table         | created_table                                                                 |
+---------------+-------------------------------------------------------------------------------+
| client_events | CREATE TABLE `client_events` (                                                |
|               | `time` TIMESTAMP(9) NOT NULL,                                                 |
|               | `client_clientid` STRING NOT NULL,                                            |
|               | `cluster_id` STRING NOT NULL,                                                 |
|               | `span_name` STRING NOT NULL,                                                  |
|               | `trace_id` STRING NOT NULL,                                                   |
|               | `span_id` STRING NOT NULL,                                                    |
|               | `service_name` STRING,                                                        |
|               | `span_kind` STRING,                                                           |
|               | `end_time_unix_nano` INT64,                                                   |
|               | `duration_nano` INT64,                                                        |
|               | `attributes` STRING,                                                          |
|               | `parent_span_id` STRING,                                                      |
|               | `client_connect_authn_result` STRING,                                         |
|               | `authz_publish_result` STRING,                                                |
|               | `client_subscribe_topics` STRING,                                             |
|               | `authz_subscribe_result` STRING,                                              |
|               | `service_instance_id` STRING,                                                 |
|               | `client_unsubscribe_topics` STRING,                                           |
|               | `client_subscribe_sub_opts` STRING,                                           |
|               | `otel_status_code` STRING,                                                    |
|               | `otel_status_description` STRING,                                             |
|               | timestamp key(`time`)                                                         |
|               | )                                                                             |
|               | PARTITION BY HASH (`client_clientid`, `cluster_id`, `span_name`) PARTITIONS 1 |
|               | ENGINE=TimeSeries                                                             |
|               | with (                                                                        |
|               | TTL='30d',                                                                    |
|               | STORAGE_TYPE='LOCAL'                                                          |
|               | )                                                                             |
|               |                                                                               |
+---------------+-------------------------------------------------------------------------------+
```

```sql
drop table client_events
```

```sql
select count(*) from client_events
```

```sql
select span_id, parent_span_id, span_name, client_clientid from client_events
```

__message_events__:

```sql
CREATE TABLE `message_events` (
`time` TIMESTAMP(9) NOT NULL,
`client_clientid` STRING NOT NULL,
`cluster_id` STRING NOT NULL,
`span_name` STRING NOT NULL,
`trace_id` STRING NOT NULL,
`span_id` STRING NOT NULL,
`service_name` STRING,
`span_kind` STRING,
`end_time_unix_nano` INT64,
`duration_nano` INT64,
`attributes` STRING,
`parent_span_id` STRING,
`message_from` STRING,
`message_topic` STRING,
`message_msgid` STRING,
`service_instance_id` STRING,
`otel_status_code` STRING,
`otel_status_description` STRING,
timestamp key(`time`)
)
PARTITION BY HASH (`client_clientid`, `cluster_id`, `span_name`) PARTITIONS 1
ENGINE=TimeSeries
with (
STORAGE_TYPE='LOCAL',
TTL='30d'
)
```

```sql
show create table message_events
+----------------+-------------------------------------------------------------------------------+
| table          | created_table                                                                 |
+----------------+-------------------------------------------------------------------------------+
| message_events | CREATE TABLE `message_events` (                                               |
|                | `time` TIMESTAMP(9) NOT NULL,                                                 |
|                | `client_clientid` STRING NOT NULL,                                            |
|                | `cluster_id` STRING NOT NULL,                                                 |
|                | `span_name` STRING NOT NULL,                                                  |
|                | `trace_id` STRING NOT NULL,                                                   |
|                | `span_id` STRING NOT NULL,                                                    |
|                | `service_name` STRING,                                                        |
|                | `span_kind` STRING,                                                           |
|                | `end_time_unix_nano` INT64,                                                   |
|                | `duration_nano` INT64,                                                        |
|                | `attributes` STRING,                                                          |
|                | `parent_span_id` STRING,                                                      |
|                | `message_from` STRING,                                                        |
|                | `message_topic` STRING,                                                       |
|                | `message_msgid` STRING,                                                       |
|                | `service_instance_id` STRING,                                                 |
|                | `otel_status_code` STRING,                                                    |
|                | `otel_status_description` STRING,                                             |
|                | timestamp key(`time`)                                                         |
|                | )                                                                             |
|                | PARTITION BY HASH (`client_clientid`, `cluster_id`, `span_name`) PARTITIONS 1 |
|                | ENGINE=TimeSeries                                                             |
|                | with (                                                                        |
|                | STORAGE_TYPE='LOCAL',                                                         |
|                | TTL='30d'                                                                     |
|                | )                                                                             |
|                |                                                                               |
+----------------+-------------------------------------------------------------------------------+
```

```sql
drop table message_events
```

```sql
select count(*) from message_events
```

```sql
select span_id, parent_span_id, span_name, client_clientid from message_events
```
