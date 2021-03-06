module JavaParser
  class Java
    attr_accessor :property_rules, :class_rules
    include DTO
    include Const
    include CommonMethod

    def initialize()
      self.class_rules = Array.new()
      self.class_rules.push(/class\s*(\w*)\s*{[\s*\w*\W*]*}/i)

      self.property_rules = Array.new()
      self.property_rules.push(/public\s*(datetime|date|int|float|long|string|char|boolean|short|byte|long|double)\s*(\w*)\s*;/i)
    end

    #start of parsing code =begin
    def parse(code)
      class_and_fields = split_by_line(code, 0)[:line]
      # input result to fields array
      return class_and_fields
    end

    def split_by_line(code,level)
      result_array = Array.new()
      end_line_index = code.index ";"
      open_block_index = code.index "{"
      close_block_index = code.index "}"
      count = 0
      last_index = 0

      # prepare the result in form of class dto_line_structure
      until end_line_index == 0 and open_block_index == 0 and close_block_index == 0 do
        result = DtoLineStructure.new()
        result.holder = Array.new()

        #get the first { or ; or }
        end_line_index = code.index ";"
        end_line_index = 0 if end_line_index == nil
        open_block_index = code.index "{"
        open_block_index = 0 if open_block_index == nil
        close_block_index = code.index "}"
        close_block_index = 0 if close_block_index == nil

        new_line_start_index = 0

        # get the scenario
        scenario = :open_block
        min = open_block_index
        if end_line_index < min or min == 0  then
          min  = end_line_index
          scenario = :end_line
        end
        if close_block_index < min or min == 0 then
          scenario = :close_block
        end

        #process based on scenario
        case scenario
          when :open_block
            # start to slice the block
            block = code.slice(open_block_index+1,code.length)
            line_from_block = split_by_line(block,level+1)

            length_of_block = line_from_block[:last_block_index]
            line_structure = line_from_block[:line]
            # put data to holder
            result.line = code.slice(0,open_block_index + 1) + "block}"
            result.mapped_line = self.parse_line(result.line)
            result.holder = line_structure
            # get the last index to start again
            code = code.slice(open_block_index + 1 + length_of_block, code.length )
            last_index = last_index + open_block_index + 1 + length_of_block

          when :end_line
            line = code.slice(0,end_line_index+1)
            result.line = line
            result.mapped_line = self.parse_line(result.line)
            # get the last index to start again
            code = code.slice(end_line_index+1, code.length)
            last_index = last_index + end_line_index + 1

          when :close_block
            last_index = last_index + close_block_index + 1
            break
        end
        result_array.push(result)
      end

      return {:line => result_array, :last_block_index =>last_index}

    end

    def parse_line(line)
      result = DtoFieldsInCode.new()
      # TODO: Create into one big regex, it's much better than few small regex
      self.property_rules.each do |prop_rule|
        mapped_line = line.scan prop_rule
        if mapped_line.any? then
          result.type = put_to_common_type mapped_line[0][0]
          result.name = mapped_line[0][1]
          result.theme = create_random_theme result.type
          break
        end
      end
      self.class_rules.each do |class_rule|
        mapped_line = line.scan class_rule
        if mapped_line.any? then
          result.type = "Class"
          result.name = mapped_line[0][0]
        end
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
              line_code = "#{" " * (indent_count+2)}public String #{property.mapped_line.name} { get; set; }"
            when "Number","number"
              line_code = "#{" " * (indent_count+2)}public Int #{property.mapped_line.name} { get; set; }"
            when "DateTime","Date","Time"
              line_code = "#{" " * (indent_count+2)}public DateTime #{property.mapped_line.name} { get; set; }"
            when "Boolean"
              line_code = "#{" " * (indent_count+2)}public Boolean #{property.mapped_line.name} { get; set; }"
            when "Class"
              line_code = create_code(property,indent_count+2)
          end
        property_lines.push line_code if not line_code.empty?
      end
      result = "#{" " * indent_count}public Class #{class_line.mapped_line.name} {\n#{property_lines.join("\n")}\n} "
      return result
    end

    # start to create line of code from generated data
    def reparse_data(generated_data)
      count = 0
      result = Array.new
      generated_data.each do |class_container|
        result.push "#{class_container.name}[] result = new #{class_container.name}[#{class_container.properties.length}];"
        class_container.properties.each do |new_dummy_data|

          code_data = Array.new
          new_dummy_data.each do |name,value|
            unless value.is_a?(Time) then
              code_data.push "#{name}=#{value}"
            else
              code_data.push "#{name}= new DateTime(#{value.year},#{value.month},#{value.day},#{value.hour},#{value.min},#{value.sec})"
            end
          end
          #create the data
          result.push "#{class_container.name} model#{count} = new #{class_container.name}(){#{code_data.join ","}};"
          result.push "result[#{count}] = model#{count};"
          count += 1
        end
      end
      return result
    end


  end
end
