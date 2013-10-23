module DTO
  class DtoFieldsInCode
    attr_accessor :name, :type, :length, :theme
  end

  class DtoLineStructure
    attr_accessor :line, :mapped_line, :holder
  #  mapped_line << DtoFieldsInCode.new
  end

  class DtoGeneratedDataStructure
    attr_accessor :name, :properties, :theme, :length
  end

  class Object
    def not_nil?
      !nil?
    end
  end

end
