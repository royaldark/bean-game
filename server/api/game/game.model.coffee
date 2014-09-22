"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema

Card = new Schema(
  name: String
  gold: [Number]
)

GameSchema = new Schema(
  name: String
  players: [
    name: String
    hand: [Card]
  ]
  drawPile: [Card]
  discardPile: [Card]
  currentTurn:
    player: String
    phase: Number
)

module.exports = mongoose.model("Game", GameSchema)
