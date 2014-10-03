'use strict'

angular.module 'beansApp'
.controller 'PlayGameCtrl', ($rootScope, $scope, $stateParams, socket, api) ->
  $scope.playGame =
    gameId: $stateParams.gameId
    playerIndex: null
    game: null

    phases: [
      'Plant bean cards'
      'Draw, trade and donate bean cards'
      'Plant traded and donated cards'
      'Draw new bean cards'
    ]

    errorHandler: (response) ->
      console.log response.data?.error

    imagePath: (card) ->
      cardPath = card.name.toLowerCase().replace(' ', '-')
      "/assets/images/cards/#{cardPath}.png"

    plant: (card, field) ->
      api.post("games/#{@gameId}/plant/#{card._id}/field/#{field}", clientId: $rootScope.clientKey)
      .catch(@errorHandler)

    buyBeanField: ->
      api.post("games/#{@gameId}/buyBeanField", clientId: $rootScope.clientKey)
      .catch(@errorHandler)

    join: (playerIndex) ->
      api.post("games/#{@gameId}/join/#{playerIndex}", clientId: $rootScope.clientKey)
      .then (response) =>
        @playerIndex = _.findIndex(response.data.players, { clientId: $rootScope.clientKey })
      .catch(@errorHandler)

  api.get("games/#{$stateParams.gameId}").success (game) ->
    $scope.playGame.game = game
    socket.socket.on 'game:save', (game) ->
      $scope.playGame.game = game
