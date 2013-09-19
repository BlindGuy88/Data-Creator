angular.module("dummy_ang_module",['ui.select2']).
controller('CodeController', ["$scope","$http","$timeout", ($scope, $http, $timeout)->
  # ------------------------starting to put function --------------------------
  $scope.generate_field_option = ->
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
            theme = {}
            theme[property_type] = $scope.option_theme[property_type]
            klass.properties.push({"name":property_name, "type":property_type, "length":20, "theme":"Person Name", instance_theme:theme})
          $scope.classes.push(klass)

#          $scope.$apply()
#          $("[ui-select2]").select2({ containerCss:'selecttwo'});

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
  $scope.generate_data = ->
    url = "generate_data"
    successresponse = (data)->
      $scope.dummy_data_for_user = data.data
#    $http.get(url,{params:{language:$scope.code_language,data:window.myCodeMirror.getValue()}}).success(successresponse)
    $http.get(url,{params:{language:$scope.code_language,data:$scope.raw_code,data_count:$scope.data_count_number}}).success(successresponse)
    return

  #calling to generate data with specific theme
  $scope.generate_data_with_theme = ->
    url = "generate_data_from_option"
    successresponse = (data)->
      $scope.raw_code = data.raw_code
      $scope.dummy_data_for_user = data.data
    #    $http.get(url,{params:{language:$scope.code_language,data:window.myCodeMirror.getValue()}}).success(successresponse)
    $http.get(url,{params:{language:$scope.code_language, classes:$scope.classes, data_count:$scope.data_count_number}}).success(successresponse)
    return

  #calling to tell that code have been changed
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

  #calling to tell that theme have changed
  $scope.change_theme = (property)->
    #change the option theme, according to the type
    property.instance_theme = {}
    property.instance_theme[property.type] = $scope.option_theme[property.type]
    #change the value to become the first value
    #watch the property, so if there any changes... it can be responsive

    if (property.instance_theme[property.type].length > 0)
      property.theme = ""
      $timeout( ->
        property.theme = property.instance_theme[property.type][0]
      , 0
      )

  #trying to populate optionTheme
  $scope.populate_option_theme = ->
    optgroup = $("[optionTheme] optgroup")
    for opt in optgroup
      text = opt.label
      $scope.option_type.push(text)
      $scope.option_theme[text] = []
      options = $(opt).children("option")
      for option in options
        text_option = option.text
        $scope.option_theme[text].push(text_option)



  # ------------------------starting to put property --------------------------
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
  $scope.option_theme = {}
  $scope.option_type = []
  $scope.populate_option_theme()

  return
])