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

    imagePath: (card) ->
      cardPath = card.name.toLowerCase().replace(' ', '-')
      "/assets/images/cards/#{cardPath}.png"

    plant: (card) ->
      api.post("games/#{$stateParams.gameId}/plant/#{card._id}/field/0")

    buyBeanField: ->
      api.post("games/#{$stateParams.gameId}/buyBeanField")


  api.get("games/#{$stateParams.gameId}").success (game) ->
    $scope.playGame.game = game
    socket.socket.on 'game:save', (game) ->
      $scope.playGame.game = game
