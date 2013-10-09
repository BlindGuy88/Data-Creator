module SQLParser
  class SQL
    attr_accessor :property_rules, :class_rules
    include DTO
    include Const
    include CommonMethod

    def initialize()

      self.class_rules = Array.new
      self.class_rules.push /CREATE\sTABLE\s+(\w+|["]\w+["])\s*[(]([\s\S\w\W]*)[)]/i

      self.property_rules = Array.new
      self.property_rules.push (/\s*(\w*)\s*(\w*)([(]([\w]*)[)])?\s*[",",\s*\z]/)
    end

    #start of parsing sql * i don't think we need to break this to lines, just put it directly to holder *
    def parse(code)
      # straight to parse line
      result = search_for_table (code)
      return result
    end

    def search_for_table(code)
        result = Array.new
        classes = code.scan class_rules[0]
        classes.each do |sql_class|
           table = DtoLineStructure.new
           table.line = "CREATE TABLE #{sql_class[0]} ( ... )"
           table.mapped_line = DtoFieldsInCode.new
           table.mapped_line.name = sql_class[0]
           table.mapped_line.type = "Class"
           fields = self.parse_line(sql_class[1])
           table.holder = fields
           result.push table
        end
      return result
    end

    def parse_line(line)
      result = Array.new
      fields = line.scan property_rules[0]
      fields.each do |field|
          result_field = DtoLineStructure.new
          result_field.line = "#{field[0]} #{field[1]}"
          fieldMapped = DtoFieldsInCode.new
          fieldMapped.name = field[0]
          fieldMapped.type = put_to_common_type field[1]
          fieldMapped.theme = create_random_theme fieldMapped.type
          fieldMapped.length = (field[3] || 0)
          result_field.mapped_line = fieldMapped
          result.push result_field
      end
      return result
    end

# --------------------------------------------------Reparser code
# start of reparsing code
    def reparse_code(array_structured_lines)
      result = Array.new
      array_structured_lines.each do |structured_line|
        if not structured_line.mapped_line.nil?
          if structured_line.mapped_line.type == "Class"
            string_code = create_code(structured_line,0)
            result.push string_code
          end
        end
      end
      return result.join("\n")
    end

    def create_code(class_line,indent_count)
      property_lines = Array.new
      class_line.holder.each do |property|
        line_code = ""
        case property.mapped_line.type
          when "text", "Text"
            line_code = "#{" " * (indent_count+2)} #{property.mapped_line.name} Varchar#{ if property.mapped_line.length.nil? then "(#{property.mapped_line.length})" else "(#{255})" end }"
          when "Number","number"
            line_code = "#{" " * (indent_count+2)} #{property.mapped_line.name} INT"
          when "Class"
            line_code = create_code(property,indent_count+2)
        end
        property_lines.push line_code if not line_code.empty?
      end
      result = "#{" " * indent_count}CREATE TABLE #{class_line.mapped_line.name} (\n#{property_lines.join("\n")}\n);"
      return result
    end

# start to create line of code from generated data
    def reparse_data(generated_data)
      count = 0
      result = Array.new
      generated_data.each do |class_container|
        prop_array = Array.new
        already_filled = false
        class_container.properties.each do |new_dummy_data|
          count += 1
          value_array = Array.new
          new_dummy_data.each do |name,value|
            unless already_filled then prop_array.push name end
            value_array.push value
          end
          already_filled = true
          #create the data
          result.push "INSERT INTO #{class_container.name}(#{prop_array.join ","}) VALUES(#{value_array.join ","}) "

        end
      end
      return result
    end


  end
end
