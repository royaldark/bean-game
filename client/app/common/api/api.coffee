'use strict'

angular.module('beansApp').factory 'api', ($http) ->
  _dir = 'api'

  _route = (path) ->
    "/#{_dir}/#{path}"

  _makeRequest = (method, path, data, opts) ->
    $http[method](_route(path), data, opts)

  get = (path, opts) ->
    _makeRequest 'get', path, null, opts

  post = _.partial(_makeRequest, 'post')

  put = _.partial(_makeRequest, 'put')

  # Delete is a reserved word
  deleat = _.partial(_makeRequest, 'delete')

  return {
    get
    post
    put
    delete: deleat
  }
