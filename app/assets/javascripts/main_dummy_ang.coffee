angular.module("dummy_ang_module",[]).
controller('CodeController', ["$scope","$http", ($scope, $http)->
  #starting to put properti here
  $scope.classes = []
  $scope.data_count_number = 20
  $scope.code_language = "C#"
  $scope.raw_code =
    " public Class exampleClass \r\n
    {\r\n
      public string ArtistName {get; set;}\r\n
      public string AlbumName {get; set; }\r\n
      public int AlbumYear{get;set;}\r\n
      public int TrackCount{get;set;}\r\n
    }"

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
        $scope.classes = []
        #starting to put the data into the fields
        for classes in data.data
          klass = new Object()
          klass.name = classes.mapped_line.name
          klass.properties = []
          properties = classes.holder
          for property in properties
            property_name = property.mapped_line.name
            property_type = property.mapped_line.type
            klass.properties.push({"name":property_name, "type":property_type, "length":20, "theme":"Person"})
          $scope.classes.push(klass)

      #call ajax and send the code to server
      targeturl = $("[data-target-url]").first().attr("data-target-url")
#      $http.get(targeturl, {params:{language:$scope.code_language,data:window.myCodeMirror.getValue()}} ).success(successResponse)
      $http.get(targeturl, {params:{language:$scope.code_language,data:$scope.raw_code,data_count:$scope.data_count_number}} ).success(successResponse)
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
#    $http.get(url,{params:{language:$scope.code_language,data:window.myCodeMirror.getValue()}}).success(successresponse)
    $http.get(url,{params:{language:$scope.code_language,data:$scope.raw_code,data_count:$scope.data_count_number}}).success(successresponse)
    return

  #calling to generate data
  $scope.generatedatawiththeme = ->
    url = "generate_data_from_option"
    successresponse = (data)->
      $scope.raw_code = data.raw_code
      $scope.dummy_data_for_user = data.data
    #    $http.get(url,{params:{language:$scope.code_language,data:window.myCodeMirror.getValue()}}).success(successresponse)
    $http.get(url,{params:{language:$scope.code_language, classes:$scope.classes, data_count:$scope.data_count_number}}).success(successresponse)
    return

  $scope.change_code_type = (code_type)->
    switch code_type
      when "C"
#        window.myCodeMirror.setOption('mode','text/x-csrc')
        alert('put into C mode')
      when "SQL"
        alert('put into SQL mode')
      when "C++"
        alert('put into C++ mode')
      when "C#"
#        window.myCodeMirror.setOption('mode','text/x-csharp')
        alert('put into C# mode')
      when "Pascal"
        alert('put into Pascal mode')
      when "Java"
        alert('put into Java mode')
      when "Ruby"
        alert('put into Ruby mode')
      when "Python"
#        window.myCodeMirror.setOption('mode','ruby')
        alert('put into Python mode')
      else
        alert('language error')
    $scope.code_language = code_type

  return
])