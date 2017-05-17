class MatrixUtil
  # Class to manipulate Matrix
  class << self

    # Method to set Matrix by row and col
    #
    # @param matrix [Matrix] a Matrix object
    # @param row [Integer] row position
    # @param col [Integer] col position
    # @param value [String, Integer] the value you want to put
    # @return [Matrix]
    def set_element(matrix, row, col, value)
      arr = matrix.to_a
      arr[row-1][col-1] = value
      Matrix.rows(arr)
    end

    # Method to set Matrix's col from row_start to row_end
    #
    # @param matrix [Matrix] a Matrix object
    # @param col [Integer] col position
    # @param row_start [Integer] row start position
    # @param row_end [Integer] row end position
    # @param value [String, Integer] the value you want to put
    # @return [Matrix]
    def set_col(matrix, col, row_start, row_end, value)
      arr = matrix.to_a
      arr.each_with_index do |sub, index|
        next unless (index + 1 >= row_start) && (index + 1 <= row_end)
        sub[col-1] = value
      end
      Matrix.rows(arr)
    end

    # Method to set Matrix's row from col_start to col_end
    #
    # @param matrix [Matrix] a Matrix object
    # @param row [Integer] row position
    # @param col_start [Integer] col start position
    # @param col_end [Integer] col end position
    # @param value [String, Integer] the value you want to put
    # @return [Matrix]
    def set_row(matrix, row, col_start, col_end, value)
      arr = matrix.to_a
      arr[row - 1] = arr[row - 1].each_with_index.map do |sub, index|
        ((index + 1 >= col_start) && (index + 1 <= col_end)) ? value : sub
      end
      Matrix.rows(arr)
    end
  end
end
