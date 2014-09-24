"use strict"
_ = require 'lodash'
Q = require 'q'
Game = require './game.model'

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

CARDS_PER_PLAYER = 5

handleError = (res, error) ->
  res.json 500, { error }

findGameById = Q.nbind(Game.findById, Game)

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
  reduceFn = ({ deck, players }, player) ->
    deck: _.rest(deck, CARDS_PER_PLAYER)
    players: players.concat([
      name: player.name
      hand: _.take(deck, CARDS_PER_PLAYER)
      fields: [{ cards: [] }, { cards: [] }]
      gold: 0
      clientId: null
    ])

  initialState =
    deck: _.shuffle(NEW_DECK)
    players: []

  { deck, players } = _.reduce(req.body.players, reduceFn, initialState)

  game = _.extend {}, req.body,
    players: players
    drawPile: deck
    discardPile: []
    currentTurn:
      player: req.body.players[0].name
      phase: 0
      number: 0

  Game.create game, (err, game) ->
    return handleError(res, err) if err
    res.json 201, game

_findCardInHand = (players, cardId) ->
  for player, playerIndex in players
    for card, cardIndex in player.hand
      if card._id.toString() == cardId
        return { card, player, cardIndex, playerIndex }

  return null

_getPlayerById = (game, playerId) ->
  _.find game.players, (player) ->
      player._id.toString() == playerId

_getPlayerByClientId = (game, clientId) ->
  _.find(game.players, { clientId })

exports.plantCard = (req, res) ->
  findGameById(req.params.id)
  .then (game) ->
    { player, card, cardIndex, playerIndex } = _findCardInHand(game.players, req.params.cardId)
    fieldIndex = req.params.fieldId

    if 0 > fieldIndex > 2
      return handleError(res, 'Invalid field.')
    else if fieldIndex == 2 and player.fields.length < 2
      return handleError(res, 'Player has not yet bought 3rd beanfield.')
    else if game.currentTurn.phase not in [0, 2]
      return handleError(res, 'Cards cannot be planted during this phase of the turn.')
    else
      player.fields[fieldIndex].cards.push card
      player.hand.splice(cardIndex, 1)

    Q.ninvoke(game, 'save')
  .then (game) ->
    res.json 200, game
  .catch(_.partial(handleError, res))

exports.harvest = (req, res) ->
  findGameById(req.params.id)
  .then (game) ->
    player = game.players[0]
    fieldIndex = req.params.fieldId

    if 0 > fieldIndex > player.fields.length
      return handleError(res, 'Invalid field.')

    cards = player.fields[fieldIndex].cards
    numToHarvest = cards.length

    gold = 0
    for numNeeded, index in cards[0].gold
      if numToHarvest >= numNeeded
        gold = index + 1

    player.gold += gold

    game.discardPile.push(cards...)
    player.fields[fieldIndex].cards = []

    Q.ninvoke(game, 'save')
  .then (game) ->
    res.json 200, game
  .catch(_.partial(handleError, res))

_draw = (game, player, numToDraw) ->
  if game.drawPile.length < numToDraw
    game.drawPile.push _.shuffle(game.discardPile)...
    game.discardPile = []

  player.hand.push _.take(game.drawPile, numToDraw)...
  game.drawPile = _.rest(game.drawPile, numToDraw)

exports.drawTwo = (req, res) ->
  findGameById(req.params.id)
  .then (game) ->
    player = game.players[0]
    if game.currentTurn.phase != 1
      return handleError(res, 'You cannot draw 2 during this phase.')

    _draw(game, player, 2)

    Q.ninvoke(game, 'save')
  .then (game) ->
    res.json 200, game
  .catch(_.partial(handleError, res))

exports.join = (req, res) ->
  findGameById(req.params.id)
  .then (game) ->
    player = _findPlayerById(game, req.params.playerId)

    if not player
      return handleError(res, 'No such player.')

    player.clientId = req.body.clientId

    Q.ninvoke(game, 'save')
  .then (game) ->
    res.json 200, game
  .catch(_.partial(handleError, res))

exports.drawThree = (req, res) ->
  findGameById(req.params.id)
  .then (game) ->
    player = game.players[0]
    if game.currentTurn.phase != 3
      return handleError(res, 'You cannot draw 3 during this phase.')

    _draw(game, player, 3)

    Q.ninvoke(game, 'save')
  .then (game) ->
    res.json 200, game
  .catch(_.partial(handleError, res))

exports.buyBeanField = (req, res) ->
  findGameById(req.params.id)
  .then (game) ->
    player = game.players[0]
    if player.fields.length > 2
      return handleError(res, 'You cannot purchase more than 3 beanfields.')
    else if player.gold < 3
      return handleError(res, 'You do not have enough gold to purchase a 3rd beanfield.')

    player.fields.push(player.fields.create { cards: [] })
    player.gold -= 3

    Q.ninvoke(game, 'save')
  .then (game) ->
    res.json 200, game
  .catch(_.partial(handleError, res))

exports.nextPhase = (req, res) ->
  findGameById(req.params.id)
  .then (game) ->
    if game.currentTurn.phase < 3
      game.currentTurn.phase++
    else
      return handleError(res, 'This turn is already at the final phase.')

    Q.ninvoke(game, 'save')
  .then (game) ->
    res.json 200, game
  .catch(_.partial(handleError, res))

exports.nextTurn = (req, res) ->
  findGameById(req.params.id)
  .then (game) ->
    game.currentTurn.number++
    game.currentTurn.phase = 0
    Q.ninvoke(game, 'save')
  .then (game) ->
    res.json 200, game
  .catch(_.partial(handleError, res))

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
