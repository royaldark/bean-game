'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var GameSchema = new Schema({
  name: String,
  players: Array
});

module.exports = mongoose.model('Game', GameSchema);
