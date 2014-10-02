###*
Socket.io configuration
###
"use strict"

crypto = require 'crypto'
config = require './environment'
gameController = require '../api/game/game.controller'

clients = {}

hash = (socket) ->
  crypto.createHash('md5').update(key(socket)).digest('hex')

key = (socket) ->
  "#{socket.address}:#{socket.client.id}"

# When the user disconnects.. perform this
onDisconnect = (socket) ->
  clientHash = key(socket)
  delete clients[clientHash]
  gameController.disconnect(clientHash)

# When the user connects.. perform this
onConnect = (socket) ->
  clientHash = hash(socket)

  socket.clientId = clientHash
  socket.emit 'key', clientHash

  # When the client emits 'info', this listens and executes
  socket.on "info", (data) ->
    console.info "[%s:%s] %s", socket.address, clientHash, JSON.stringify(data, null, 2)
    return

  # Insert sockets below
  require("../api/thing/thing.socket").register socket
  require("../api/game/game.socket").register socket
  return

module.exports = (socketio) ->
  # socket.io (v1.x.x) is powered by debug.
  # In order to see all the debug output, set DEBUG (in server/config/local.env.js) to including the desired scope.
  #
  # ex: DEBUG: "http*,socket.io:socket"

  # We can authenticate socket.io users and access their token through socket.handshake.decoded_token
  #
  # 1. You will need to send the token in `client/components/socket/socket.service.js`
  #
  # 2. Require authentication here:
  # socketio.use(require('socketio-jwt').authorize({
  #   secret: config.secrets.session,
  #   handshake: true
  # }));
  socketio.on "connection", (socket) ->
    socket.connectedAt = new Date()
    console.log socket.client.id
    socket.address = socket.handshake.address ? process.env.DOMAIN

    # Call onDisconnect.
    socket.on "disconnect", ->
      onDisconnect(socket)
      console.info "[%s:%s] DISCONNECTED", socket.address, hash(socket)

    # Call onConnect.
    onConnect(socket)
    console.info "[%s:%s] CONNECTED", socket.address, hash(socket)
