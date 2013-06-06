# SFDB Ruby Client

A simple ruby client to interact with [SFDB](https://github.com/ryandotsmith/sfdb).

## Usage

```ruby
db = SFDB.new('localhost:8000')
uuid = SecureRandom.uuid
db.put(uuid, 'hello world')
db.get(uuid)
```
