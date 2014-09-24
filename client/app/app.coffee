'use strict'

angular.module 'beansApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'btford.socket-io',
  'ui.router',
  'ui.bootstrap'
]
.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $urlRouterProvider
  .otherwise '/'

  $locationProvider.html5Mode true
.run ($rootScope, socket) ->
  $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
    console.log "Error transitioning:
      #{fromState.name}(#{JSON.stringify fromParams}) ->
      #{toState.name}(#{JSON.stringify toParams})"

    # Stop the state change
    event.preventDefault()

  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    console.log "Beginning transition:
      #{fromState.name}(#{JSON.stringify fromParams}) ->
      #{toState.name}(#{JSON.stringify toParams})"

  $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
    console.log "Successfully transitioned:
      #{fromState.name}(#{JSON.stringify fromParams}) ->
      #{toState.name}(#{JSON.stringify toParams})"

  socket.socket.on 'key', (key) ->
    console.log "Client key: #{key}"
    $rootScope.clientKey = key
