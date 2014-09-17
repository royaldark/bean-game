angular.module 'beansApp'
.config ($stateProvider) ->
  $stateProvider

  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'

  .state 'game',
    url: '/games'
    abstract: true

  .state 'game.new',
    url: '/new'
    views:
      '@':
        templateUrl: 'app/game/new.html'
        controller: 'NewGameCtrl'

  .state 'game.play',
    url: '/:gameId',
    templateUrl: 'app/game/play.html'
    controller: 'PlayGameCtrl'
