angular.module("dummy_ang_module",[]).
controller('CodeController', ["$scope","$http", ($scope, $http)->
  #starting to put properti here
  $scope.code = "halo halo bandung"
  $scope.fields = []
  $scope.fields.push({"name":"testing", "type":"varchar","length":"100", "theme":"safari"})

  #starting to put function
  $scope.givebacksomething = ->
    $scope.fields.push({"name":"testing", "type":"varchar","length":"100", "theme":"safari"})
    #preparing the function for success response
    successResponse = (data)->
      $scope.fields.push({"name":"testing", "type":"varchar","length":"100", "theme":"safari"})
      $scope.fields.push({"name":"testing", "type":"varchar","length":"100", "theme":"safari"})
      $scope.fields = $scope.fields
      alert($scope.fields)

    #call ajax and send the code to server
    targeturl = $("[data-target-url]").first().attr("data-target-url")
    $http.get(targeturl).success(successResponse)

    return
    #get the response and put it into the view

#  @CodeController.$inject = ['$scope','$http']

  return
])