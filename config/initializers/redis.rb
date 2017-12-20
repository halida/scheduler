require "redis"

def redis_connect!(index=0)
  Redis.current = Redis.new(host: Settings.redis.host, port: Settings.redis.port)
end

