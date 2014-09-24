###
Broadcast updates to client when the model changes
###
"use strict"
game = require './game.model'
_ = require 'lodash'

onSave = (socket, game, cb) ->
  clientIds = _(game.players)
    .map 'clientId'
    .compact()
    .value()

  if socket.clientId in clientIds
    console.log "Emitting game:save"
    socket.emit "game:save", game

onRemove = (socket, doc, cb) ->
  socket.emit "game:remove", doc

exports.register = (socket) ->
  game.schema.post "save", (doc) ->
    onSave socket, doc

  game.schema.post "remove", (doc) ->
    onRemove socket, doc
