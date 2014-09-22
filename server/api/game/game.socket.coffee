###
Broadcast updates to client when the model changes
###
"use strict"
game = require("./game.model")

onSave = (socket, doc, cb) ->
  socket.emit "game:save", doc

onRemove = (socket, doc, cb) ->
  socket.emit "game:remove", doc

exports.register = (socket) ->
  game.schema.post "save", (doc) ->
    onSave socket, doc

  game.schema.post "remove", (doc) ->
    onRemove socket, doc
