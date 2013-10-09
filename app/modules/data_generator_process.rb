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
           unless mapped_line.type.nil? then
             if (mapped_line.type == "Text" )
               dummy_data[mapped_line.name] = "\"#{self.data_based_on_theme(mapped_line.theme)}\""
             end
             if (mapped_line.type == "Number" )
               dummy_data[mapped_line.name] = data_based_on_theme mapped_line.theme
             end
             if (mapped_line.type == Const::ThemeName::Date )
               dummy_data[mapped_line.name] = data_based_on_theme mapped_line.theme
             end
             if (mapped_line.type == "Boolean" )
               dummy_data[mapped_line.name] = rand(2) == 0
             end
           end
         end
         result.push(dummy_data)
        end
      return result
    end

    def data_based_on_theme(theme)
      case theme
        when Const::ThemeName::PersonName
           result = Faker::Name.name
        when Const::ThemeName::Address
          result = Faker::Address.street_address
        when Const::ThemeName::StreetName
          result = Faker::Address.street_name
        when Const::ThemeName::PhoneNumber
          result = Faker::PhoneNumber.phone_number
        when Const::ThemeName::Year
          result = 1980 + rand(2013-1980)
        when Const::ThemeName::EmailName
          result = Faker::Internet.email
        when Const::ThemeName::CompanyName
          result = Faker::Company.name
        when Const::ThemeName::LoremIpsum
          result = Faker::Lorem.sentence
        when Const::ThemeName::Random
          result = 1980 + rand(2013-1980)
        when Const::ThemeName::BirthDate
          result = create_date_between 1988, 2010
        when Const::ThemeName::CCExpired
          result = create_date_between 2010, 2015

        when "random"
          result = "random"
      end
      return result
    end

    def create_date_between(start_year, end_year)
      start_year_epoch = (Time.new start_year).to_f
      end_year_epoch = (Time.new end_year).to_f
      max = [start_year_epoch, end_year_epoch].max
      min = [start_year_epoch, end_year_epoch].min
      return Time.at(min + rand(max - min))
    end

  end

end