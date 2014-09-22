"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema
Card = new Schema(
  name: String
  gold: [Number]
)
TurnState = new Schema(
  drawPile: [Card]
  discardPile: [Card]
  playerHands: [
    player: String
    arr: [Card]
  ]
  whoseTurn: String
)
GameSchema = new Schema(
  name: String
  players: Array
  turnStates: [TurnState]
)
module.exports = mongoose.model("Game", GameSchema)
