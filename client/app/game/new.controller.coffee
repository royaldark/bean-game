'use strict'

angular.module 'beansApp'
.controller 'NewGameCtrl', ($scope, $http, $state, socket, api) ->

  api.get('games').success (awesomeThings) ->
    $scope.games = awesomeThings
    socket.syncUpdates 'game', $scope.games

  _.extend $scope,
    games: []
    players: [{}, {}]

    addPlayer: ->
      @players.push {}

    newGame: ->
      api.post('games',
        name: @gameTitle
        players: @players
      ).then(
        (response) ->
          $state.go 'game.play', { gameId: response.data._id }
      )

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'game'
