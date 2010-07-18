include credis

CREDIS_VERSION_STRING_SIZE: extern Int
CREDIS_MULTIPLEXING_API_SIZE: extern Int
CREDIS_USED_MEMORY_HUMAN_SIZE: extern Int

RedisInfo: cover from REDIS_INFO {
  redis_version: extern Char[CREDIS_VERSION_STRING_SIZE]
  arch_bits: extern Int
  multiplexing_api: extern Char[CREDIS_MULTIPLEXING_API_SIZE]
  process_id: extern Long
  uptime_in_seconds: extern Long
  uptime_in_days: extern Long
  connected_clients: extern Int
  connected_slaves: extern Int
  blocked_clients: extern Int
  used_memory: extern ULong
  used_memory_human: extern Char[CREDIS_USED_MEMORY_HUMAN_SIZE]
  changes_since_last_save: extern LLong
  bgsave_in_progress: extern Int
  last_save_time: extern Long
  bgrewriteaof_in_progress: extern Int
  total_connections_received: extern LLong
  total_commands_processed: extern LLong
  expired_keys: extern LLong
  hash_max_zipmap_entries: extern ULong
  hash_max_zipmap_value: extern ULong
  pubsub_channels: extern Long
  pubsub_patterns: extern UInt;
  vm_enabled: extern Int;
  role: extern Int;
}

Redis: cover from Void* {
  new: extern(credis_connect) static func (host :String, port: Int, timeout: Int) -> Redis
  close: extern(credis_close) func ()
  info: extern(credis_info) func (info: RedisInfo*) -> Int
}

