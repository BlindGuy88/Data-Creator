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
               class_structure.length = structured_line.mapped_line.length
               class_structure.properties = create_data_for_a_class structured_line, count
               result.push class_structure
             end
          end
      end
      return result
    end

    def create_data_for_a_class(class_line,count)
      result = Array.new
      in_context_length = Hash.new

      # starting to create data for each number
      count.times do |number|
       dummy_data = nil
       class_line.holder.each do |properties_line|
         mapped_line = properties_line.mapped_line

         # starting to create data foreach hash
         if dummy_data.nil? then
           dummy_data = Hash.new
         end

         #if exist use that one, if not exist start to create one
         if (in_context_length.keys.include? mapped_line.length)
           active_length = in_context_length[mapped_line.length]
         else
           if (mapped_line.type == Const::TypeName::Date )
             active_length = parse_date_length mapped_line.length
           else
             active_length = parse_number_length mapped_line.length
           end
         end

         unless mapped_line.type.nil? then
           if (mapped_line.type == "Text" )
             dummy_data[mapped_line.name] = "\"#{self.data_based_on_theme(mapped_line.theme, active_length, number)}\""
           end
           if (mapped_line.type == "Number" )
             dummy_data[mapped_line.name] = data_based_on_theme mapped_line.theme, active_length, number
           end
           if (mapped_line.type == Const::TypeName::Date )
             dummy_data[mapped_line.name] = data_based_on_theme mapped_line.theme, active_length, number
           end
           if (mapped_line.type == Const::TypeName::Boolean)
             dummy_data[mapped_line.name] = data_based_on_theme mapped_line.theme, active_length, number
           end
         end
       end
       result.push(dummy_data)
      end
      return result
    end

    def  data_based_on_theme(theme, length, data_count)
      case theme
        # TEXT --------------------------------------------------------
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
          if length.length > 0
            then random_number = length[rand(length.length)]
            else random_number = 1 + rand(20)
          end
          result = Faker::Lorem.sentence(random_number)
        when Const::ThemeName::GUID
          result = SecureRandom.uuid
        # Number --------------------------------------------------------
        when Const::ThemeName::Random
          if length.length > 0
          then random_number = length[rand(length.length)]
          else random_number = 1 + rand(100)
          end
          result = random_number
        when Const::ThemeName::Increment
          if length.length > 0
          then calculated_number = length[0] +data_count
          else calculated_number = data_count
          end
          result = calculated_number
        # Dste --------------------------------------------------------
        when Const::ThemeName::BirthDate
          if length.length > 0
            lower_bound = length[0]
            top_bound = length[1]
          else
            lower_bound = DateTime.new(1988)
            top_bound = DateTime.new(1988)
          end
          result = create_date_between lower_bound, top_bound
        when Const::ThemeName::CCExpired
          if length.length > 0
            lower_bound = length[0]
            top_bound = length[1]
          else
            lower_bound = DateTime.new(2010)
            top_bound = DateTime.new(2015)
          end
          result = create_date_between lower_bound, top_bound
        # Boolean --------------------------------------------------------
        when Const::ThemeName::TrueFalse
          result = rand(2)==0
        when Const::ThemeName::True
          result = true
        when Const::ThemeName::False
          result = false
        when "random"
          result = "random"
      end
      return result
    end

    def parse_number_length(the_length)
      result = Array.new
      if (the_length != nil)
        split_result = the_length.split(%r{\s*[,;]\s*})
        split_result.each do |sp_length|
          element = nil
          check_range = sp_length.split %r{\s*[-]\s*}
          if (check_range.length > 1)
            if check_range[0].to_i > check_range[1].to_i
              then element =  (check_range[1].to_i..check_range[0].to_i).to_a
              else element =  (check_range[0].to_i..check_range[1].to_i).to_a
            end
          elsif (check_range.length == 1)
             element = [sp_length.to_i]
          end
          result.concat element unless element.in? result
        end
      end
      return result
    end

    def parse_date_length(the_length)
      result = Array.new
      unless the_length.nil?
        # if only one field filled
        if the_length.length == 1
          unless the_length[0].nil? then active_date = the_length[0] else active_date = the_length[1] end
          result[0]=active_date
          result[1]=active_date
        end
        # if both field filled put it in order
        if the_length.length == 2
          if the_length[0] > the_length[1]
            min_date = the_length[1]
            max_date = the_length[0]
          else
            min_date = the_length[0]
            max_date = the_length[1]
          end
          result[0]=min_date
          result[1]=max_date
        end
      end
      return result
    end

    def random_number_from_array_number(array_of_number)

    end

    def create_date_between(start_year, end_year)
      start_year_epoch = start_year.to_f
      end_year_epoch = end_year.to_f
      max = [start_year_epoch, end_year_epoch].max
      min = [start_year_epoch, end_year_epoch].min
      return Time.at(min + rand(max - min))
    end

  end

end