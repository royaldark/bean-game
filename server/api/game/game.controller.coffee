handleError = (res, err) ->
  res.send 500, err
"use strict"
_ = require("lodash")
Game = require("./game.model")

CARD_TYPES = [
  name: 'Coffee Bean'
  quantity: 24
  gold: [4, 7, 10, 12]
,
  name: 'Wax Bean'
  quantity: 22
  gold: [4, 7, 9, 11]
,
  name: 'Blue Bean'
  quantity: 20
  gold: [4, 6, 8, 10]
,
  name: 'Chili Bean'
  quantity: 18
  gold: [3, 6, 8, 9]
,
  name: 'Stink Bean'
  quantity: 16
  gold: [3, 5, 7, 8]
,
  name: 'Green Bean'
  quantity: 14
  gold: [3, 5, 6, 7]
,
  name: 'Soy Bean'
  quantity: 12
  gold: [2, 4, 6, 7]
,
  name: 'Black-Eyed Bean'
  quantity: 10
  gold: [2, 4, 5, 6]
,
  name: 'Red Bean'
  quantity: 8
  gold: [2, 3, 4, 5]
,
  name: 'Garden Bean'
  quantity: 6
  gold: [null, 2, 3, null]
,
  name: 'Cocoa Bean'
  quantity: 4
  gold: [null, 2, 3, 4]
]

NEW_DECK = _.flatten(
  for type in CARD_TYPES
    card = _.omit(type, ['quantity'])
    for instance in [1..type.quantity]
      card
)

exports.index = (req, res) ->
  Game.find (err, games) ->
    return handleError(res, err)  if err
    res.json 200, games

exports.show = (req, res) ->
  Game.findById req.params.id, (err, game) ->
    return handleError(res, err)  if err
    return res.send(404)  unless game
    res.json game

exports.create = (req, res) ->
  reduceFn = ({ deck, hands }, player) ->
    deck: _.rest(deck, 7)
    hands: hands.concat([
      player: player.name
      arr: _.take(deck, 7)
    ])

  initialState =
    deck: _.shuffle(NEW_DECK)
    hands: []

  { deck, hands } = _.reduce(req.body.players, reduceFn, initialState)

  game = _.extend {}, req.body,
    turnStates: [
      drawPile: deck
      discardPile: []
      playerHands: hands
      whoseTurn: req.body.players[0].name
    ]

  Game.create game, (err, game) ->
    return handleError(res, err)  if err
    res.json 201, game

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Game.findById req.params.id, (err, game) ->
    return handleError(res, err)  if err
    return res.send(404)  unless game
    updated = _.merge(game, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.json 200, game

exports.destroy = (req, res) ->
  Game.findById req.params.id, (err, game) ->
    return handleError(res, err)  if err
    return res.send(404)  unless game
    game.remove (err) ->
      return handleError(res, err)  if err
      res.send 204
