use redis

info : RedisInfo
redis := Redis new(null, 0, 10000)
rc := redis info(info&)

printf("info returned %d\n", rc)
printf("> redis_version: %s\n", info redis_version);
printf("> arch_bits: %d\n", info arch_bits);
printf("> multiplexing_api: %s\n", info multiplexing_api);
printf("> process_id: %ld\n", info process_id);
printf("> uptime_in_seconds: %ld\n", info uptime_in_seconds);
printf("> uptime_in_days: %ld\n", info uptime_in_days);
printf("> connected_clients: %d\n", info connected_clients);
printf("> connected_slaves: %d\n", info connected_slaves);
printf("> blocked_clients: %d\n", info blocked_clients);
printf("> used_memory: %zu\n", info used_memory);
printf("> used_memory_human: %s\n", info used_memory_human);
printf("> changes_since_last_save: %lld\n", info changes_since_last_save);
printf("> bgsave_in_progress: %d\n", info bgsave_in_progress);
printf("> last_save_time: %ld\n", info last_save_time);
printf("> bgrewriteaof_in_progress: %d\n", info bgrewriteaof_in_progress);
printf("> total_connections_received: %lld\n", info total_connections_received);
printf("> total_commands_processed: %lld\n", info total_commands_processed);
printf("> expired_keys: %lld\n", info expired_keys);
printf("> hash_max_zipmap_entries: %zu\n", info hash_max_zipmap_entries);
printf("> hash_max_zipmap_value: %zu\n", info hash_max_zipmap_value);
printf("> pubsub_channels: %ld\n", info pubsub_channels);
printf("> pubsub_patterns: %u\n", info pubsub_patterns);
printf("> vm_enabled: %d\n", info vm_enabled);
printf("> role: %d\n", info role);

redis close()
