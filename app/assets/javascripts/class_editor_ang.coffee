angular.module("class_editor_module",['ui.select2'])
.controller("ClassEditor",["$scope","$http","$timeout", ($scope,$http,$timeout) ->

    #----------------------- do the initial here -----------------------------
    $scope.init = ->
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
      $scope.option_theme = {}
      $scope.option_type = []
      $scope.populate_option_theme()
      $scope.generate_field_option()

    #simulate generate field option for testing
    $scope.generate_field_option = ->
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

        #call ajax and send the code to server
        targeturl = $("[data-target-url]").first().attr("data-target-url")
        #      $http.get(targeturl, {params:{language:$scope.code_language,data:window.myCodeMirror.getValue()}} ).success(successResponse)
        $http.get(targeturl, {params:{language:$scope.code_language,data:$scope.raw_code,data_count:$scope.data_count_number}} ).success(successResponse)

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

    $scope.add_field = (a_class)->
      the_class = a_class
      property= {}
      property.name = ""
      property.length = ""
      property.theme = ""
      property.instance_theme = ""
      the_class.properties.push(property)

    $scope.remove_field = (a_class,property)->
      object_index = a_class.properties.indexOf property
      count_object = 1
      a_class.properties.splice object_index, count_object
  ])