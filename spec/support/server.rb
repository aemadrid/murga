def find_open_port
  socket = Socket.new(:INET, :STREAM, 0)
  socket.bind Addrinfo.tcp('0.0.0.0', 0)
  port = socket.local_address.ip_port
  socket.close
  port
end
