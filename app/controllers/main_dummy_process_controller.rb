
class MainDummyProcessController < ApplicationController
  include CSharpParser
  include DTO
  include DataGeneratorProcess

  def show
  end

  def get_code_field
    # get the code
    code_language = params[:language]
    raw_code = params[:data]
    data_count = params[:data_count]
    # parse the code
    array_of_structured_lines = self.parse_code code_language,raw_code

    respond_to do |format|
      format.json {render :json => {"data" => array_of_structured_lines}.to_json}
      format.html {render :json => {"data" => array_of_structured_lines}.to_json}
    end
  end

  def generate_data
    # get the code
    code_language = params[:language]
    raw_code = params[:data]
    data_count = params[:data_count].to_i
    # parse the code
    array_of_structured_lines = self.parse_code code_language,raw_code
    generator = DataGenerator.new
    generated_data = generator.generate_data array_of_structured_lines,data_count
    generated_data_in_language = self.reparse_data code_language,generated_data

    # generate the data from the field
    data = generate_dummy_data
    respond_to do |format|
      format.json {render :json => {"data" => generated_data_in_language.join("\n")}.to_json}
      format.html {render :json => {"data" => generated_data_in_language.join("\n")}.to_json}
    end
    return
  end

  def dummy_data
    code_language = "C#"
    array_of_structured_lines = self.parse_code(code_language,"
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
    #use_code = "PrintModel model = new PrintModel(){PrinterName:"",PrinterDescription:"",NumberOfJobs:0,TotalPages:0}"
    generator = DataGenerator.new
    generated_data = generator.generate_data array_of_structured_lines,20
    generated_data_in_language = self.reparse_data code_language,generated_data

    c_sharp = CSharp.new
    code = c_sharp.reparse_code(array_of_structured_lines)

    respond_to do |format|
      format.json {render :json => {"data" => generated_data_in_language, "code" => code}.to_json}
      format.html {render :json => {"data" => generated_data_in_language, "code" => code}.to_json}
    end

  end

  def parse_code (code_language, code)
    result = nil
    case code_language
      when "C#"
        # call module C to parse this code
        # or call factory to create parse
        c_sharp = CSharp.new
        result = c_sharp.parse(code)
        code = c_sharp.reparse_code(result)
    end
    return result
  end

  def reparse_data (code_language, generated_data)
    result = ""
    case code_language
      when "C#"
        # call module C to parse this code
        # or call factory to create parse
        c_sharp = CSharp.new
        result = c_sharp.reparse_data(generated_data)
    end
    return result
  end
  #def generate_data (array_of_parsed_lines, count)
  #    data_generator = new data
  #end

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
