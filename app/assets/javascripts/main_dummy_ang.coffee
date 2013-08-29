angular.module("dummy_ang_module",[]).
controller('CodeController', ["$scope","$http", ($scope, $http)->
  #starting to put properti here
  $scope.dummy_data_for_user = 'exampleClass var1 = new exampleClass ("james morrison","Feeling like a teenager", "1991", "12")\n
exampleClass var2 = new exampleClass ("Faye Wong","Eyes on me", "1997", "7")\n
exampleClass var3 = new exampleClass ("lady gaga","Judas", "2012", "11")\n
exampleClass var4 = new exampleClass ("peter pan","yang terbaik untuk mu", "2000", "12")\n
exampleClass var5 = new exampleClass ("The Blues","Jazzy in the city", "1987", "5")\n
exampleClass var6 = new exampleClass ("Beatles","Yellow submarine", "1978", "14")\n
exampleClass var7 = new exampleClass ("Morgana","Yellow oasis", "1992", "13")\n
exampleClass var8 = new exampleClass ("Sing in the Rain","To The City", "1988", "9")\n
exampleClass var9 = new exampleClass ("Lion king","Hakuna matata", "1991", "12")\n'
  target_collapse = $("#field_option > ul")
  window.collapse = "hidden"

  #starting to put function
  $scope.givebacksomething = ->
    if (window.collapse == "hidden")
      #preparing the function for success response
      successResponse = (data)->
        $scope.fields = []
        arrayfields = data.data
        #get the response and put it into the view
        arrayfields.forEach (field)->
          if (field.name? and field.type? and field.length? and field.theme?)
            $scope.fields.push({"name":field.name, "type":field.type,"length":field.length, "theme":field.theme})

      #call ajax and send the code to server
      targeturl = $("[data-target-url]").first().attr("data-target-url")
      $http.get(targeturl).success(successResponse)
      $(target_collapse).show()
      window.collapse = "shown"
    else
      $("#field_option > ul").hide()
      window.collapse = "hidden"
    return

  #calling to generate data
  $scope.generatedata = ->
    url = "generate_data"
    successresponse = (data)->
      $scope.dummy_data_for_user = data.data
    $http.get(url).success(successresponse)
  return

  return
])