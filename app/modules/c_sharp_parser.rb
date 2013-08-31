module CSharpParser
  include DTO

  class CSharp

    def parse(code)

      # starting to cut down here and there
      # split by { ; } first
      # split by reserved word
      # create reserved word list


      code.split


      # input result to fields array
      array_fields = Array.new()

      data = DtoFieldsInCode.new()
      data.name = "Name"
      data.type = "Varchar"
      data.length = "100"
      data.theme = "Person Name"

      array_fields.push(data2)
      return array_fields
    end

  end

end
