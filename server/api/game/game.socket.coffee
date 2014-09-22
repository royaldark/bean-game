###*
Broadcast updates to client when the model changes
###
onSave = (socket, doc, cb) ->
  socket.emit "game:save", doc
  return
onRemove = (socket, doc, cb) ->
  socket.emit "game:remove", doc
  return
"use strict"
game = require("./game.model")
exports.register = (socket) ->
  game.schema.post "save", (doc) ->
    onSave socket, doc
    return

  game.schema.post "remove", (doc) ->
    onRemove socket, doc
    return

  return
