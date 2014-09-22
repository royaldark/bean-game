
# Get list of games

# Get a single game

# Creates a new game in the DB.

# Updates an existing game in the DB.

# Deletes a game from the DB.
handleError = (res, err) ->
  res.send 500, err
"use strict"
_ = require("lodash")
Game = require("./game.model")
exports.index = (req, res) ->
  Game.find (err, games) ->
    return handleError(res, err)  if err
    res.json 200, games

  return

exports.show = (req, res) ->
  Game.findById req.params.id, (err, game) ->
    return handleError(res, err)  if err
    return res.send(404)  unless game
    res.json game

  return

exports.create = (req, res) ->
  Game.create req.body, (err, game) ->
    return handleError(res, err)  if err
    res.json 201, game

  return

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Game.findById req.params.id, (err, game) ->
    return handleError(res, err)  if err
    return res.send(404)  unless game
    updated = _.merge(game, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.json 200, game

    return

  return

exports.destroy = (req, res) ->
  Game.findById req.params.id, (err, game) ->
    return handleError(res, err)  if err
    return res.send(404)  unless game
    game.remove (err) ->
      return handleError(res, err)  if err
      res.send 204

    return

  return
