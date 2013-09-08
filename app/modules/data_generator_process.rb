module DataGeneratorProcess

  #require 'faker'
  class DataGenerator
    include DTO
    include Const

    def generate_data(array_structured_lines, count)
      result = Array.new
      array_structured_lines.each do |structured_line|
          if not structured_line.mapped_line.nil?
             if structured_line.mapped_line.type == "Class"
               class_structure = DtoGeneratedDataStructure.new
               class_structure.name = structured_line.mapped_line.name
               class_structure.properties = create_data_for_a_class structured_line, count
               result.push class_structure
             end
          end
      end
      return result
    end

    def create_data_for_a_class(class_line,count)
      result = Array.new
        count.times do |number|
         dummy_data = nil
         class_line.holder.each do |properties_line|
           # starting to create data foreach hash
           if dummy_data.nil? then
             dummy_data = Hash.new
           end
           mapped_line = properties_line.mapped_line
           if not mapped_line.type.nil? and (mapped_line.type == "String" or mapped_line.type == "string")
             dummy_data[mapped_line.name.to_s] = "\"#{self.data_based_on_theme(mapped_line)}\""
           end
           if not mapped_line.type.nil? and (mapped_line.type == "int" or mapped_line.type == "Int")
             dummy_data[mapped_line.name] = Faker::PhoneNumber.phone_number
           end
         end
         result.push(dummy_data)
        end
      return result
    end

    def data_based_on_theme(mapped_line)
      result = nil

      case mapped_line.theme
        when Const::ThemeName::PersonName
           result = Faker::Name.name
        when Const::ThemeName::Address
          result = Faker::Address.street_address
        when Const::ThemeName::StreetName
          result = Faker::Address.street_name
        when Const::ThemeName::PhoneNumber
          result = Faker::PhoneNumber.phone_number
        when Const::ThemeName::EmailName
          result = Faker::Internet.email
        when Const::ThemeName::CompanyName
          result = Faker::Company.name
        when Const::ThemeName::LoremIpsum
          result = Faker::Lorem.sentence
        when Const::ThemeName::Year
          result = rand([1980..2013])
        when "random"
          result = "random"
      end
      return result
    end

  end

end