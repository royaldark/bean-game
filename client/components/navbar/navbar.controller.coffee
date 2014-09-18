'use strict'

angular.module 'beansApp'
.controller 'NavbarCtrl', ($scope, $location) ->
  $scope.menu = [
    title: 'Home'
    link: '/'
  ,
    title: 'New Game'
    link: '/games/new'
  ]
  $scope.isCollapsed = true

  $scope.isActive = (route) ->
    route is $location.path()
