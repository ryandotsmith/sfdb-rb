require 'socket'
require 'securerandom'

class SFDB
  DEBUG = ENV['DEBUG'] || false

  VERSION = '1'
  def initialize(*servers)
    @conns = servers.map do |s|
      TCPSocket.new(*s.split(':'))
    end
  end

  def put(id, data)
    req = fmt('p', id, data)
    conn.write(req)
    resp = read_resp(conn)
    id, _ = unfmt(resp)
    id
  end

  def get(id)
    req = fmt('g', id)
    conn.write(req)
    resp = read_resp(conn)
    id, body = unfmt(resp)
    body
  end

  private

  def read_resp(c)
    n = c.readpartial(6).to_i
    puts("respeonse-length=#{n}") if DEBUG
    resp = c.read(n)
    puts("response=#{resp}") if DEBUG
    resp
  end

  def unfmt(str)
    version = str.slice!(0,1)
    cmd = str.slice!(0,1)
    id = str.slice!(0,36)
    [id, str]
  end

  def fmt(cmd, id, body="")
    req = VERSION + cmd + id + body
    req = sprintf("%06d%s", req.length, req)
    puts("req=#{req}") if DEBUG
    req
  end
  
  def conn
    @conns.first
  end
end

