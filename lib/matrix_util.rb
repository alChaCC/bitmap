class MatrixUtil
  class << self
    def set_element(matrix, row, col, value)
      arr = matrix.to_a
      arr[row-1][col-1] = value
      Matrix.rows(arr)
    end
  end
end
