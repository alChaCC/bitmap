class MatrixUtil
  class << self
    def set_element(matrix, row, col, value)
      arr = matrix.to_a
      arr[row-1][col-1] = value
      Matrix.rows(arr)
    end

    def set_col(matrix, col, row_start, row_end, value)
      arr = matrix.to_a
      arr.each_with_index do |sub, index|
        next unless (index + 1 >= row_start) && (index + 1 <= row_end)
        sub[col-1] = value
      end
      Matrix.rows(arr)
    end
  end
end
