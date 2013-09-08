module DTO
  class DtoFieldsInCode
    attr_accessor :name, :type, :length, :theme
  end

  class DtoLineStructure
    attr_accessor :line, :mapped_line, :holder
  end

  class DtoGeneratedDataStructure
    attr_accessor :name, :properties, :theme
  end

  class Object
    def not_nil?
      !nil?
    end
  end

end
