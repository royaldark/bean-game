'use strict'

angular.module 'beansApp'
.controller 'PlayGameCtrl', ($scope, $stateParams, socket, api) ->
  $scope.playGame =
    game: null
    phases: [
      'Plant bean cards'
      'Draw, trade and donate bean cards'
      'Plant traded and donated cards'
      'Draw new bean cards'
    ]

  api.get("games/#{$stateParams.gameId}").success (game) ->
    $scope.playGame.game = game
