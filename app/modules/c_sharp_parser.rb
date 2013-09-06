

module CSharpParser

  class CSharp
    include DTO
    def self.parse(code)
      # starting to cut down here and there
      # split by { ; } first
      # split by reserved word
      # create reserved word list
      holder = DtoLineStructure.new()
      holder.line = ""

      lines = Array.new
      lines = split_by_line(code, 0)

      # input result to fields array
      array_fields = Array.new()
      return array_fields
    end

    def self.split_by_line(code,level)
      result_array = Array.new()
      end_line_index = code.index ";"
      open_block_index = code.index "{"
      close_block_index = code.index "}"
      count = 0
      last_index = 0

      # prepare the result in form of class DtolineStructure
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

        case scenario
          when :open_block
            # start to slice the block
            block = code.slice(open_block_index+1,code.length)
            line_from_block = split_by_line(block,level+1)

            length_of_block = line_from_block[:last_block_index]
            line_structure = line_from_block[:line]
            # put data to holder

            result.line = code.slice(0,open_block_index + 1) + "block}"
            result.holder = line_structure

            # get the last index to start again
            code = code.slice(open_block_index + 1 + length_of_block, code.length )
            last_index = last_index + open_block_index + 1 + length_of_block

          when :end_line
            line = code.slice(0,end_line_index+1)
            result.line = line
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

    def self.parse_line(line)
      DtoFieldsInCode
    end

  end


  class LineHolder
    attr_accessor :line, :block
  end

end
