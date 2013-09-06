
class MainDummyProcessController < ApplicationController
  include CSharpParser
  include DTO

  def show
  end

  def get_code_field
    # get the code
    code_language = params[:language]
    raw_code = params[:data]
    # parse the code
    array = parse_code raw_code, code_language
    array_fields = generate_dummy_field
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

  def dummy_data
    parse_code("C#","
    class PrintModel
    {
        public string PrinterName { get; set; }
        public string PrinterDescription { get; set; }
        public int NumberOfJobs { get; set; }
        public int TotalPages { get; set; }
        public PrintQueue Printer { get; set; }

        public string AddString()
        {
            return this.PrinterName + this.PrinterDescription;
        }
    }
    ")
    #respond_to do |format|
    #  format.json {render :json => {"data" => "data"}.to_json}
    #  format.html {render :json => {"data" => "data"}.to_json}
    #end

  end

  def parse_code (code_language, code)
    case code_language
      when "C#"
        line = DtoLineStructure.new()
        line.line = "a"
        CSharp.parse(code)
        # call module C to parse this code
        # or call factory to create parse
    end

    #respond_to do |format|
    #  format.json {render :json => {"data" => data}.to_json}
    #  format.html {render :json => {"data" => data}.to_json}
    #end

  end

  def generate_dummy_field
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
