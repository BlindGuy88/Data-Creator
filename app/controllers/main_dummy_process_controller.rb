class MainDummyProcessController < ApplicationController
  include CSharpParser
  include DTO

  def show
      put_two_as_return
  end

  def get_code_field
    # parse the code
    array_fields = parse_code()
    respond_to do |format|
      format.json {render :json => {"data" => array_fields}.to_json}
      format.html {render :json => {"data" => array_fields}.to_json}
    end
  end

  def generate_data
    # generate the data from the field
    data = generate_dummy_data
    respond_to do |format|
      format.json {render :json => {"data" => data}.to_json}
      format.html {render :json => {"data" => data}.to_json}
    end
    return
  end

  def parse_code
    array_fields = Array.new()

    data = DtoFieldsInCode.new()
    data.name = "Name"
    data.type = "Varchar"
    data.length = "100"
    data.theme = "Person Name"

    data2 = DtoFieldsInCode.new()
    data2.name = "Address"
    data2.type = "Varchar"
    data2.length = "100"
    data2.theme = "Address"

    data2 = DtoFieldsInCode.new()
    data2.name = "Address"
    data2.type = "Varchar"
    data2.length = "100"
    data2.theme = "Address"

    array_fields.push(data)
    array_fields.push(data2)
    return array_fields
  end

  def generate_dummy_data
    ' Create Data From Back end
    exampleClass var1 = new exampleClass ("james morrison","Feeling like a teenager", "1991", "12")
    exampleClass var2 = new exampleClass ("Faye Wong","Eyes on me", "1997", "7")
    exampleClass var3 = new exampleClass ("lady gaga","Judas", "2012", "11")
    exampleClass var4 = new exampleClass ("peter pan","yang terbaik untuk mu", "2000", "12")
    exampleClass var5 = new exampleClass ("The Blues","Jazzy in the city", "1987", "5")
    exampleClass var6 = new exampleClass ("Beatles","Yellow submarine", "1978", "14")
    exampleClass var7 = new exampleClass ("Morgana","Yellow oasis", "1992", "13")
    exampleClass var8 = new exampleClass ("Sing in the Rain","To The City", "1988", "9")
    exampleClass var9 = new exampleClass ("Lion king","Hakuna matata", "1991", "12") '
  end

end
