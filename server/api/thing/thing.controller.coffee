###*
Using Rails-like standard naming convention for endpoints.
GET     /things              ->  index
POST    /things              ->  create
GET     /things/:id          ->  show
PUT     /things/:id          ->  update
DELETE  /things/:id          ->  destroy
###

# Get list of things

# Get a single thing

# Creates a new thing in the DB.

# Updates an existing thing in the DB.

# Deletes a thing from the DB.
handleError = (res, err) ->
  res.send 500, err
"use strict"
_ = require("lodash")
Thing = require("./thing.model")
exports.index = (req, res) ->
  Thing.find (err, things) ->
    return handleError(res, err)  if err
    res.json 200, things

  return

exports.show = (req, res) ->
  Thing.findById req.params.id, (err, thing) ->
    return handleError(res, err)  if err
    return res.send(404)  unless thing
    res.json thing

  return

exports.create = (req, res) ->
  Thing.create req.body, (err, thing) ->
    return handleError(res, err)  if err
    res.json 201, thing

  return

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Thing.findById req.params.id, (err, thing) ->
    return handleError(res, err)  if err
    return res.send(404)  unless thing
    updated = _.merge(thing, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.json 200, thing

    return

  return

exports.destroy = (req, res) ->
  Thing.findById req.params.id, (err, thing) ->
    return handleError(res, err)  if err
    return res.send(404)  unless thing
    thing.remove (err) ->
      return handleError(res, err)  if err
      res.send 204

    return

  return
