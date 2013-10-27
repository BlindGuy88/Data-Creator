class MainDummyProcessController < ApplicationController
  include CSharpParser
  include SQLParser
  include DTO
  include DataGeneratorProcess
  include Const

  # ------------------------------ Controller View --------------------------------
  def show
    @theme = Const::Theme::AvailableTheme
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

    #c_sharp = CSharp.new
    #code = c_sharp.reparse_code(array_of_structured_lines)

    respond_to do |format|
      format.json {render :json => {"data" => generated_data_in_language, "field_option" => array_of_structured_lines}.to_json}
      format.json {render :json => {"data" => generated_data_in_language, "field_option" => array_of_structured_lines}.to_json}
    end

  end

  def class_editor
    @theme = Const::Theme::AvailableTheme
    render layout:false
  end

  # ------------------------------ services        -------------------------------

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
    # create the data
    generator = DataGenerator.new
    generated_data = generator.generate_data array_of_structured_lines,data_count
    generated_data_in_language = self.put_data_into_code code_language,generated_data
    # send the data
    respond_to do |format|
      format.json {render :json => {"data" => generated_data_in_language.join("\n"), "field_option" => array_of_structured_lines}.to_json}
      format.html {render :json => {"data" => generated_data_in_language.join("\n"), "field_option" => array_of_structured_lines}.to_json}
    end
    return
  end

  def generate_data_from_field_option
    # prepare the given parameter first
    klasses_str = params[:classes]
    klasses = JSON.parse klasses_str
    data_count = params[:data_count].to_i
    code_language = params[:language]
    # convert to structured line data
    structured_line = create_structured_line_from_user_json(klasses)
    # create the data
    generator = DataGenerator.new
    generated_data = generator.generate_data structured_line,data_count
    generated_data_in_language = self.put_data_into_code code_language,generated_data
    # reparse the structure to put into the code field
    code = create_code_from_structure_line code_language, structured_line
    # give response
    respond_to do |format|
      format.json {render :json => {"raw_code" => code,"data" => generated_data_in_language.join("\n")}.to_json}
      format.html {render :json => {"raw_code" => code,"data" => generated_data_in_language.join("\n")}.to_json}
    end
  end
  # create from raw_code -> structured line
  def parse_code (code_language, code)
    result = nil
    case code_language
      when "C#"
        parser = CSharp.new
      when "SQL"
        parser = SQL.new
    end
    result = parser.parse(code)
    return result
  end

  # create from data_structure -> code_contain_data
  def create_code_from_structure_line (code_language, data_structure)
    result = nil
    case code_language
      when "C#"
        parser = CSharp.new
      when "SQL"
        parser = SQL.new
    end
    result = parser.reparse_code(data_structure)
    return result
  end

  # create from data_structure -> raw_code
  def put_data_into_code (code_language, generated_data)
    result = ""
    case code_language
      when "C#"
        parser = CSharp.new
      when "SQL"
        parser = SQL.new
    end
    result = parser.reparse_data(generated_data)
    return result
  end

  # create structured line from user field
  def create_structured_line_from_user_json(unstructured_line_array_json)
    # regenerate the holder class
    klasses = unstructured_line_array_json
    structured_line = Array.new
    if not klasses.nil? then
      klasses.each do |klass|
        class_structured = DtoLineStructure.new
        class_structured.mapped_line = DtoFieldsInCode.new
        class_structured.mapped_line.name = klass["name"]
        class_structured.mapped_line.type = "Class"
        class_structured.holder = Array.new

        klass["properties"].each do |property|
          properties_structured = DtoLineStructure.new
          properties_structured.mapped_line = DtoFieldsInCode.new
          properties_structured.mapped_line.name = property["name"]
          properties_structured.mapped_line.type = property["type"]
          properties_structured.mapped_line.theme = property["theme"]
           properties_structured.mapped_line.length = property["length"]

          unless property["dateLength"].nil?
            properties_structured.mapped_line.length = []
            property["dateLength"].each do |string_date|
              converted_date = DateTime.strptime string_date, '%d/%m/%Y %I:%M:%S %p'
              properties_structured.mapped_line.length.push converted_date
            end
          end
          class_structured.holder.push properties_structured
        end

        structured_line.push class_structured
      end
    end
    return structured_line
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

end
