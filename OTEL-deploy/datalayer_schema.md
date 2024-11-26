Schemas
将所有的 trace 事件存储到一下 2 个表中：

__client_events__:

```sql
CREATE TABLE `client_events` (
time TIMESTAMP(9) NOT NULL,
`client.clientid` STRING NOT NULL,
`attributes` STRING,
`trace_id` STRING,
span_id STRING,
`span.name` STRING,
`span.kind` STRING,
`end_time_unix_nano` INT64,
`duration_nano` INT64,
`client.connect.authn.result` STRING,
`parent_span_id` STRING,
`authz.publish.result` STRING,
`client.subscribe.topics` STRING,
`authz.subscribe.result` STRING,
`service.instance.id` STRING,
`client.unsubscribe.topics` STRING,
timestamp key(time)
)
PARTITION BY HASH (`client.clientid`) PARTITIONS 1
ENGINE=TimeSeries
```

```sql
show create table client_events;
+---------------+--------------------------------------------------+
| table         | created_table                                    |
+---------------+--------------------------------------------------+
| client_events | CREATE TABLE `client_events` (                   |
|               | time TIMESTAMP(9) NOT NULL,                      |
|               | client.clientid STRING NOT NULL,                 |
|               | attributes STRING,                               |
|               | trace_id STRING,                                 |
|               | span_id STRING,                                  |
|               | span.name STRING,                                |
|               | span.kind STRING,                                |
|               | end_time_unix_nano INT64,                        |
|               | duration_nano INT64,                             |
|               | client.connect.authn.result STRING,              |
|               | parent_span_id STRING,                           |
|               | authz.publish.result STRING,                     |
|               | client.subscribe.topics STRING,                  |
|               | authz.subscribe.result STRING,                   |
|               | service.instance.id STRING,                      |
|               | client.unsubscribe.topics STRING,                |
|               | timestamp key(time)                              |
|               | )                                                |
|               | PARTITION BY HASH (client.clientid) PARTITIONS 1 |
|               | ENGINE=TimeSeries                                |
|               |                                                  |
+---------------+--------------------------------------------------+
```

__message_events__:

```sql
CREATE TABLE `message_events` (
time TIMESTAMP(9) NOT NULL,
`client.clientid` STRING NOT NULL,
`trace_id` STRING,
`span_id` STRING,
`span.name` STRING,
`span.kind` STRING,
`attributes` STRING,
`end_time_unix_nano` INT64,
`message.from` STRING,
`message.topic` STRING,
`message.msgid` STRING,
`duration_nano` INT64,
`service.instance.id` STRING,
`parent_span_id` STRING,
timestamp key(time)
)
PARTITION BY HASH (`client.clientid`) PARTITIONS 1
ENGINE=TimeSeries
```

```sql
show create table message_events;
+----------------+------------------------------------------------+
| table          | created_table                                  |
+----------------+------------------------------------------------+
| message_events | CREATE TABLE `message_events` (                |
|                | time TIMESTAMP(9) NOT NULL,                    |
|                | client.clientid STRING NOT NULL,               |
|                | trace_id STRING,                               |
|                | span_id STRING,                                |
|                | span.name STRING,                              |
|                | span.kind STRING,                              |
|                | attributes STRING,                             |
|                | end_time_unix_nano INT64,                      |
|                | message.from STRING,                           |
|                | message.topic STRING,                          |
|                | duration_nano INT64,                           |
|                | service.instance.id STRING,                    |
|                | parent_span_id STRING,                         |
|                | message.msgid STRING,                          |
|                | timestamp key(time)                            |
|                | )                                              |
|                | PARTITION BY HASH (message.topic) PARTITIONS 1 |
|                | ENGINE=TimeSeries                              |
|                |                                                |
+----------------+------------------------------------------------+
```
