'use strict'

angular.module 'beansApp'
.controller 'PlayGameCtrl', ($scope, $stateParams, socket, api) ->
  $scope.games = []

  api.get("games/#{$stateParams.gameId}").success (game) ->
    $scope.game = game
