'use strict'

angular.module 'beansApp'
.controller 'NewGameCtrl', ($scope, $http, socket) ->
  $scope.games = []

  $http.get('/api/games').success (awesomeThings) ->
    $scope.games = awesomeThings
    socket.syncUpdates 'game', $scope.games

  _.extend $scope,
    newGame: ->
      $http.post '/api/games',
        name: @gameTitle
        players: [{name: 'Joe'}]

      @gameTitle = @numPlayers = ''

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'game'
