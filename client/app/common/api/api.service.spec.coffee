'use strict'

describe 'Service: api', ->

  # load the service's module
  beforeEach module 'beansApp'

  # instantiate service
  api = undefined
  beforeEach inject (_api_) ->
    api = _api_

  it 'should do something', ->
    expect(!!api).toBe true
