'use strict'

angular.module 'beansApp'
.controller 'PlayGameCtrl', ($rootScope, $scope, $stateParams, socket, api) ->
  $scope.playGame =
    gameId: $stateParams.gameId
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
      api.post("games/#{@gameId}/plant/#{card._id}/field/0", clientId: $rootScope.clientKey)

    buyBeanField: ->
      api.post("games/#{@gameId}/buyBeanField", clientId: $rootScope.clientKey)

    join: (playerIndex) ->
      api.post("games/#{@gameId}/join/#{playerIndex}", clientId: $rootScope.clientKey)

  api.get("games/#{$stateParams.gameId}").success (game) ->
    $scope.playGame.game = game
    socket.socket.on 'game:save', (game) ->
      $scope.playGame.game = game
