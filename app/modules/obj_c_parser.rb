module ObjCParser
  class ObjC
    attr_accessor :property_rules, :class_rules
    include DTO
    include Const
    include CommonMethod

    def initialize()
      self.class_rules = Array.new
      self.class_rules.push /@interface\s*(?<name>(\w*?))\s*:(?<result>(.|\n)*)@end/i
      #self.class_rules.push /@interface\s*(?<name>(\w*\s*)*):(\w*\s*)*[{](?<result>(\w*\s*[\/.;*]*)*)[}]/i

      self.property_rules = Array.new
      #self.property_rules.push /(?<line>(?<type>\w*)\s*[*]?(?<name>\w*))[;]/i
      self.property_rules.push /(?<line>@property\s*(\(.*?\))\s*(?<type>(\w|_|-)*?)(\s|\*)*(?<name>(\w|_|-|)*?));/i
      #@interface(\w*\s*)*:(\w*\s*)*[{](\w*\s*)*[}]
    end

    def parse(code)
      # straight to parse line
      result = search_for_table (code)
      return result
    end

    def search_for_table(code)
      result = Array.new
      classes = code.scan class_rules[0]
      classes.each do |obc_class|
        table = DtoLineStructure.new
        table.line = "@interface #{obc_class[0]}:NSObject ( ... )"
        table.mapped_line = DtoFieldsInCode.new
        table.mapped_line.name = obc_class[0]
        table.mapped_line.type = "Class"
        fields = self.parse_line(obc_class[1])
        table.holder = fields
        result.push table
      end
      return result

    end

    def parse_line(line)
      result = Array.new
      fields = line.scan property_rules[0]
      fields.each do |field|
        forbidden_word = ["constraint","primary","references"]
        if (not field[0].nil? and  field[0] != "" and !forbidden_word.include?(field[0].downcase) and field[1] != "") then
          result_field = DtoLineStructure.new
          result_field.line = field[0]
          field_mapped = DtoFieldsInCode.new
          field_mapped.name = field[2]
          field_mapped.type = put_to_common_type field[1]
          field_mapped.theme = create_random_theme field_mapped.type
          #field_mapped.length = (field[2]) unless field[2].nil?
          result_field.mapped_line = field_mapped
          result.push result_field
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
      interface_lines = Array.new
      class_line.holder.each do |property|
        line_code = ""
        interface_code = ""
        case property.mapped_line.type
          when "text", "Text"
            line_code = "#{" " * (indent_count+2)}@property (nonatomic,retain) NSString *#{property.mapped_line.name}"
            interface_code = "#{" " * (indent_count+2)}NSString *#{property.mapped_line.name}"
          when "Date","date"
            line_code = "#{" " * (indent_count+2)}@property (nonatomic,retain) NSDate *#{property.mapped_line.name}"
            interface_code = "#{" " * (indent_count+2)}NSDate *#{property.mapped_line.name}"
          when "Number","number"
            line_code = "#{" " * (indent_count+2)}@property (nonatomic,retain) NSNumber *#{property.mapped_line.name}"
            interface_code = "#{" " * (indent_count+2)}NSNumber *#{property.mapped_line.name}"
          when "Boolean","boolean"
            line_code = "#{" " * (indent_count+2)}@property (nonatomic,retain) BOOL #{property.mapped_line.name}"
            interface_code = "#{" " * (indent_count+2)}BOOL #{property.mapped_line.name}"
          when "Class"
            line_code = create_code(property,indent_count+2)
        end
        property_lines.push line_code if not line_code.empty?
        interface_lines.push interface_code if not interface_code.empty?

      end
      result = "@interface #{class_line.mapped_line.name} : NSObject\n{\n#{interface_lines.join ";\n"};\n}
#{property_lines.join ";\n"};
@end"
      #result = "#{" " * indent_count}CREATE TABLE #{class_line.mapped_line.name} (\n#{property_lines.join(",\n")}\n);"
      return result
    end

# start to create line of code from generated data
    def reparse_data(generated_data)
      count = 0
      result = Array.new
      top_syntax = "NSMutableArray *result = [NSMutableArray alloc] init];"
      date_formatter = "NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                        dateFormater.timeStyle = NSDateFormatterNoStyle;
                        dateFormater.dateFormat = @\"yyyy-MM-dd HH:mm:ss\"; \n"
      result.push top_syntax
      result.push date_formatter
      generated_data.each do |class_container|
        class_container.properties.each do |new_dummy_data|
          unless new_dummy_data.nil?
            count += 1
            top_line = "NSObject *created#{count} = [#{class_container.name} new];"
            lines = Array.new
              new_dummy_data.each do |name,value|
                if value.instance_of? String and value[0] == "\""
                  line = "created#{count}.#{name} = @#{value};"
                elsif value.instance_of? Time
                  line = "created#{count}.#{name} = [dateFormater dateFromString:@\"#{value}\"];"
                else
                  line = "created#{count}.#{name} = #{value};"
                end
                lines.push line
              end
            bot_line = "[result addObject:created#{count}];"
            result.push top_line + "\n" + lines.join("\n") +"\n"+ bot_line + "\n"
          end
        end
      end

      return result
    end


  end
end
