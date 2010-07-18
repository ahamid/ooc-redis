include credis

CREDIS_OK: extern Int
CREDIS_ERR: extern Int
CREDIS_ERR_NOMEM: extern Int
CREDIS_ERR_RESOLVE: extern Int
CREDIS_ERR_CONNECT: extern Int
CREDIS_ERR_SEND: extern Int
CREDIS_ERR_RECV: extern Int
CREDIS_ERR_TIMEOUT: extern Int
CREDIS_ERR_PROTOCOL: extern Int

CREDIS_TYPE_NONE: extern Int
CREDIS_TYPE_STRING: extern Int
CREDIS_TYPE_LIST: extern Int
CREDIS_TYPE_SET: extern Int

CREDIS_SERVER_MASTER: extern Int
CREDIS_SERVER_SLAVE: extern Int

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

Data: cover from Char*

Redis: cover from Void* {
  /*
   * Connection handling
   */

  /* setting host to NULL will use "localhost". setting port to 0 will use 
   * default port 6379 */
  new: extern(credis_connect) static func (host: const String, port: Int, timeout: Int) -> Redis

  close: extern(credis_close) func ()
  quit: extern(credis_quit) func ()
  auth: extern(credis_auth) func(password: const String) -> Int
  ping: extern(credis_ping) func() -> Int

  /* 
   * Commands operating on all the kind of values
   */

  /* returns -1 if the key doesn't exists and 0 if it does */
  exists: extern(credis_exists) func (key: const String) -> Int

  /* returns -1 if the key doesn't exists and 0 if it was removed 
   * TODO add support to (Redis >= 1.1) remove multiple keys 
   */
  del: extern(credis_del) func (key: const String) -> Int

  /* returns type, refer to CREDIS_TYPE_* defines */
  type: extern(credis_type) func (key: const String) -> Int

  /* returns number of keys returned in vector `keyv' */
  keys: extern(credis_keys) func (pattern: const String, keyv: String **) -> Int

  randomkey: extern(credis_randomkey) func (key: String *) -> Int

  rename: extern(credis_rename) func (key: const String, new_key_name: const String) -> Int

  /* returns -1 if the key already exists */
  renamenx: extern(credis_renamenx) func (key: const String, new_key_name: const String) -> Int

  /* returns size of db */
  dbsize: extern(credis_dbsize) func () -> Int

  /* returns -1 if the timeout was not set; either due to key already has 
     an associated timeout or key does not exist */
  expire: extern(credis_expire) func (key: const String, secs: Int) -> Int

  /* returns time to live seconds or -1 if key does not exists or does not 
   * have expire set */
  ttl: extern(credis_ttl) func (key: const String) -> Int

  select: extern(credis_select) func (index: Int) -> Int

  /* returns -1 if the key was not moved; already present at target 
   * or not found on current db */
  move: extern(credis_move) func (const String, index: Int) -> Int

  flushdb: extern(credis_flushdb) func () -> Int

  flushall: extern(credis_flushall) func () -> Int

  /* 
   * Commands operating on string values 
   */

  set: extern(credis_set) func (key: const String, val: const String) -> Int

  /* returns -1 if the key doesn't exists */
  get: extern(credis_get) func (key: const String, val: String *) -> Int

  /* returns -1 if the key doesn't exists */
  getset: extern(credis_getset) func (key: const String, set_val: const String, get_val: String *) -> Int

  /* returns number of values returned in vector `valv'. `keyc' is the number of
   * keys stored in `keyv'. */
  mget: extern(credis_mget) func (keyc: Int, keyv: const String *, valv: String * *) -> Int

  /* returns -1 if the key already exists and hence not set */
  setnx: extern(credis_setnx) func (key: const String, val: const String) -> Int

  /* TODO
   * SETEX key time value Set+Expire combo command
   * MSET key1 value1 key2 value2 ... keyN valueN set a multiple keys to multiple values in a single atomic operation
   * MSETNX key1 value1 key2 value2 ... keyN valueN set a multiple keys to multiple values in a single atomic operation if none of
   */

  incr: extern(credis_incr) func (key: const String, new_val: Int *) -> Int

  incrby: extern(credis_incrby) func (key: const String, incr_val: Int , new_val: Int *) -> Int

  decr: extern(credis_decr) func (key: const String, new_val: Int *) -> Int

  decrby: extern(credis_decrby) func (key: const String, decr_val: Int, new_val: Int *) -> Int

  /* TODO
   * APPEND key value append the specified string to the string stored at key
   * SUBSTR key start end return a substring out of a larger string
   */


  /*
   * Commands operating on lists 
   */

  rpush: extern(credis_rpush) func(key: const String, element: const String) -> Int

  lpush: extern(credis_lpush) func(key: const String, element: const String) -> Int

  /* returns length of list */
  llen: extern(credis_llen) func (key: const String) -> Int

  /* returns number of elements returned in vector `elementv' */
  lrange: extern(credis_lrange) func (key: const String, start: Int, range: Int, elementv: Data * *) -> Int

  ltrim: extern(credis_ltrim) func (key: const String, start: Int, end: Int) -> Int

  /* returns -1 if the key doesn't exists */
  lindex: extern(credis_lindex) func (key: const String, index: Int, element: Data *) -> Int

  lset: extern(credis_lset) func (key: const String, index: Int, element: const Data) -> Int

  /* returns number of elements removed */
  lrem: extern(credis_lrem) func (key: const String, count: Int, element: const Data) -> Int

  /* returns -1 if the key doesn't exists */
  lpop: extern(credis_lpop) func (key: const String, val: Data*) -> Int

  /* returns -1 if the key doesn't exists */
  rpop: extern(credis_rpop) func (key: const String, val: Data*) -> Int

  /* TODO 
   * BLPOP key1 key2 ... keyN timeout Blocking LPOP
   * BRPOP key1 key2 ... keyN timeout Blocking RPOP
   * RPOPLPUSH srckey dstkey Return and remove (atomically) the last element of the source List stored at _srckey_ and push the same element to the destination List stored at _dstkey_ 
   */


  /*
   * Commands operating on sets 
   */

  /* returns -1 if the given member was already a member of the set */
  sadd: extern(credis_sadd) func (key: const String, member: const Data) -> Int

  /* returns -1 if the given member is not a member of the set */
  srem: extern(credis_srem) func (key: const String, member: const Data) -> Int

  /* returns -1 if the given key doesn't exists else value is returned in `member' */
  spop: extern(credis_spop) func (key: const String, member: Data *) -> Int

  /* returns -1 if the member doesn't exists in the source set */
  smove: extern(credis_smove) func (sourcekey: const String, destkey: const String, member: const Data) -> Int

  /* returns cardinality (number of members) or 0 if the given key doesn't exists */
  scard: extern(credis_scard) func (key: const String) -> Int

  /* returns -1 if the key doesn't exists and 0 if it does */
  sismember: extern(credis_sismember) func (key: const String, member: const Data) -> Int

  /* returns number of members returned in vector `members'. `keyc' is the number of
   * keys stored in `keyv'. */
  sInter: extern(credis_sInter) func (keyc: Int, keyv: const String*, members: Data**) -> Int

  /* `keyc' is the number of keys stored in `keyv' */
  sInterstore: extern(credis_sInterstore) func (destkey: const String, keyc: Int, keyv: const String*) -> Int

  /* returns number of members returned in vector `members'. `keyc' is the number of
   * keys stored in `keyv'. */
  sunion: extern(credis_sunion) func (keyc: Int, keyv: const String*, members: Data**) -> Int

  /* `keyc' is the number of keys stored in `keyv' */
  sunionstore: extern(credis_sunionstore) func (destkey: const String, keyc: Int , keyv: const String*) -> Int

  /* returns number of members returned in vector `members'. `keyc' is the number of
   * keys stored in `keyv'. */
  sdiff: extern(credis_sdiff) func (keyc: Int, keyv: const String*, members: Data**) -> Int

  /* `keyc' is the number of keys stored in `keyv' */
  sdiffstore: extern(credis_sdiffstore) func (destkey: const String, keyc: Int, keyv: const String*) -> Int

  /* returns number of members returned in vector `members' */
  smembers: extern(credis_smembers) func (key: const String, members: Data**) -> Int

  /* TODO Redis >= 1.1
   * SRANDMEMBER key Return a random member of the Set value at key
   */


  /* 
   * Commands operating on sorted sets (zsets, Redis version >= 1.1)
   */

  /* TODO
   *
   * ZADD key score member Add the specified member to the Sorted Set value at key or update the score if it already exist
   * ZREM key member Remove the specified member from the Sorted Set value at key
   * ZINCRBY key increment member If the member already exists increment its score by _increment_, otherwise add the member setting _increment_ as score
   * ZRANK key member Return the rank (or index) or _member_ in the sorted set at _key_, with scores being ordered from low to high
   * ZREVRANK key member Return the rank (or index) or _member_ in the sorted set at _key_, with scores being ordered from high to low
   * ZRANGE key start end Return a range of elements from the sorted set at key
   * ZREVRANGE key start end Return a range of elements from the sorted set at key, exactly like ZRANGE, but the sorted set is ordered in traversed in reverse order, from the greatest to the smallest score
   * ZRANGEBYSCORE key min max Return all the elements with score >= min and score <= max (a range query) from the sorted set
   * ZCARD key Return the cardinality (number of elements) of the sorted set at key
   * ZSCORE key element Return the score associated with the specified element of the sorted set at key
   * ZREMRANGEBYRANK key min max Remove all the elements with rank >= min and rank <= max from the sorted set
   * ZREMRANGEBYSCORE key min max Remove all the elements with score >= min and score <= max from the sorted set
   * ZUNIONSTORE / ZINTERSTORE dstkey N key1 ... keyN WEIGHTS w1 ... wN AGGREGATE SUM|MIN|MAX Perform a union or Intersection over a number of sorted sets with optional weight and aggregate
   */


  /* 
   * Commands operating on hashes
   */

  /* TODO
   * HSET key field value Set the hash field to the specified value. Creates the hash if needed.
   * HGET key field Retrieve the value of the specified hash field.
   * HMSET key field1 value1 ... fieldN valueN Set the hash fields to their respective values.
   * HINCRBY key field Integer Increment the Integer value of the hash at _key_ on _field_ with _Integer_.
   * HEXISTS key field Test for existence of a specified field in a hash
   * HDEL key field Remove the specified field from a hash
   * HLEN key Return the number of items in a hash.
   * HKEYS key Return all the fields in a hash.
   * HVALS key Return all the values in a hash.
   * HGETALL key Return all the fields and associated values in a hash.
   */


  /*
   * Sorting 
   */

  /* returns number of elements returned in vector `elementv' */
  sort: extern(credis_sort) func (query: const String, elementv: Data**) -> Int


  /*
   * Transactions
   */

  /* TODO
   * MULTI/EXEC/DISCARD Redis atomic transactions
   */


  /*
   * Publish/Subscribe
   */

  /* TODO
   * SUBSCRIBE/UNSUBSCRIBE/PUBLISH Redis Public/Subscribe messaging paradigm implementation
   */


  /* 
   * Persistence control commands 
   */

  save: extern(credis_save) func () -> Int

  bgsave: extern(credis_bgsave) func () -> Int

  /* returns UNIX time stamp of last successfull save to disk */
  lastsave: extern(credis_lastsave) func () -> Int

  shutdown: extern(credis_shutdown) func () -> Int

  /* TODO
   * BGREWRITEAOF Rewrite the append only file in background when it gets too big
   */


  /*
   * Remote server control commands 
   */

  /* Because the information returned by the Redis changes with virtually every 
   * major release, credis tries to parse for as many fields as it is aware of, 
   * staying backwards (and forwards) compatible with older (and newer) versions 
   * of Redis. 
   * Information fields not supported by the Redis server connected to, are set
   * to zero. */
  info: extern(credis_info) func (info: RedisInfo *) -> Int

  monitor: extern(credis_monitor) func () -> Int

  /* setting host to NULL and/or port to 0 will turn off replication */
  slaveof: extern(credis_slaveof) func (host: const String, port: Int) -> Int

  /* TODO
   * CONFIG Configure a Redis server at runtime
   */

}

