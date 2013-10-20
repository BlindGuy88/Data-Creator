angular.module("dummy_ang_module",['ui.select2'])
.config(["$routeProvider", ($routeProvider)->
  $routeProvider.when()
])
.controller('CodeController', ["$scope","$http","$timeout", ($scope, $http, $timeout)->

  # ------------------------starting to put function --------------------------
  $scope.generate_field_option = ->
    if ($scope.classes.$valid != true)
      alert "class not valid"
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
            property_theme = property.mapped_line.theme
            property_length = property.mapped_line.length
            # create array for the theme
            theme = {}
            theme[property_type] = $scope.option_theme[property_type]
            klass.properties.push({"name":property_name, "type":property_type, "length":property_length, "theme":property_theme, instance_theme:theme})
          $scope.classes.push(klass)

      #call ajax and send the code to server
      targeturl = $("[data-target-url]").first().attr("data-target-url")
#      $http.get(targeturl, {params:{language:$scope.code_language,data:window.myCodeMirror.getValue()}} ).success(successResponse)
      $http.get(targeturl, {params:{language:$scope.code_language,data:$scope.raw_code,data_count:$scope.data_count_number}} ).success(successResponse)
    return

  #calling to generate data
  $scope.generate_data = ->
    url = "generate_data"
    successresponse = (data)->
        $scope.dummy_data_for_user = data.data
        $scope.classes = []
        #starting to put the data into the fields
        for classes in data["field_option"]
          klass = new Object()
          klass.name = classes.mapped_line.name
          klass.properties = []
          properties = classes.holder
          for property in properties
            property_name = property.mapped_line.name
            property_type = property.mapped_line.type
            property_theme = property.mapped_line.theme
            property_length = property.mapped_line.length
            # create array for the theme
            theme = {}
            theme[property_type] = $scope.option_theme[property_type]
            klass.properties.push({"name":property_name, "type":property_type, "length":property_length, "theme":property_theme, instance_theme:theme})
          $scope.classes.push(klass)
#    $http.get(url,{params:{language:$scope.code_language,data:window.myCodeMirror.getValue()}}).success(successresponse)
    $http.get(url,{params:{language:$scope.code_language,data:$scope.raw_code,data_count:$scope.data_count_number}}).success(successresponse)
    return

  #calling to generate data with specific theme
  $scope.generate_data_with_theme = ->
    #TODO: Create a checking if class name and field name not empty
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
        $scope.raw_code = rawcode_my_sql
      when "SQL"
        $scope.raw_code = rawcode_sql
      when "C++"
        $scope.raw_code = rawcode_c_plus
      when "C#"
        $scope.raw_code = rawcode_c_sharp
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

  #add field
  $scope.add_field = (a_class)->
    the_class = a_class
    property= {}
    property.name = ""
    property.length = ""
    property.theme = ""
    property.instance_theme = ""
    the_class.properties.push(property)

  #remove field
  $scope.remove_field = (a_class,property)->
    object_index = a_class.properties.indexOf property
    count_object = 1
    a_class.properties.splice object_index, count_object

  #create class for New Class
  $scope.new_class = ()->
    #TODO: Create a checking if raw data exist.. if yes give warning, if no go proceed
    $scope.classes = []
    klass = new Object()
    klass.name = ""
    klass.properties = []
    $scope.add_field(klass)
    $scope.add_field(klass)
    $scope.classes.push(klass)


  # ------------------------starting to put property --------------------------
  $scope.classes = []
  $scope.data_count_number = 20
  $scope.code_language = "C#"
  rawcode_c_sharp =
    "public Class exampleClass \r\n
            {\r\n
              public string ArtistName {get; set;}\r\n
              public string AlbumName {get; set; }\r\n
              public int AlbumYear{get;set;}\r\n
              public int TrackCount{get;set;}\r\n
              public DateTime ReleaseDate{get;set;}\r\n
              public bool onSale {get;set;}\r\n
            }"
  rawcode_c_plus =
    "class Time { \r\n
       private: \r\n
       string ArtistName;       \r\n
       int AlbumYear;    \r\n
       public:         \r\n
       string AlbumName;   \r\n
       int TrackCount;     \r\n
    };"

  rawcode_c =
    " typedef struct {          \r\n
      char ArtistName[], AlbumNamae[]     \r\n
      int width, height;         \r\n
    } RectangleClass;"

  rawcode_obj_c =
    "@interface Bar : NSObject {   \r\n
        Foo *someFoo;              \r\n
    }"

  rawcode_sql =
  "CREATE TABLE Persons            \r\n
    (                              \r\n
      PersonID int,                \r\n
      LastName varchar(255),       \r\n
      FirstName varchar(255),      \r\n
      Address varchar(255),        \r\n
      City varchar(255)            \r\n
    ); "

  rawcode_my_sql =
    "CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20), species VARCHAR(20), sex CHAR(1), birth DATE, death DATE)"

  $scope.raw_code = rawcode_c_sharp

  $scope.dummy_data_for_user = 'exampleClass var1 = new exampleClass ("james morrison","Feeling like a teenager", "1991", "12")\n
    exampleClass var2 = new exampleClass ("Faye Wong","Eyes on me", "1997", "7")\n
    exampleClass var3 = new exampleClass ("lady gaga","Judas", "2012", "11")\n
    exampleClass var4 = new exampleClass ("peter pan","yang terbaik untuk mu", "2000", "12")\n
    exampleClass var5 = new exampleClass ("The Blues","Jazzy in the city", "1987", "5")\n
    exampleClass var6 = new exampleClass ("Beatles","Yellow submarine", "1978", "14")\n
    exampleClass var7 = new exampleClass ("Morgana","Yellow oasis", "1992", "13")\n
    exampleClass var8 = new exampleClass ("Sing in the Rain","To The City", "1988", "9")\n
    exampleClass var9 = new exampleClass ("Lion king","Hakuna matata", "1991", "12")\n'

  target_collapse = $("#field_option div")
  window.collapse = "hidden"
  $scope.option_theme = {}
  $scope.option_type = []
  $scope.populate_option_theme()

  #initializing the zero clipboard
  clip = new ZeroClipboard $("#copyToClipboard"), {moviePath: "/assets/ZeroClipboard.swf"}
  $("#copyToClipboardInfo").hide()

  clip.on 'complete', (client, args) ->
    if $scope.delay? then clearTimeout($scope.delay)
    $("#copyToClipboardInfo").fadeIn()
    $scope.delay = setTimeout( ->
      $("#copyToClipboardInfo").fadeOut()
    , 2000)

  clip.on 'dataRequested', (client, args) ->
    client.setText($scope.dummy_data_for_user)

  return
])