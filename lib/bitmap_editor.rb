require 'exceptions'
require 'Matrix'
require 'matrix_util'

class BitmapEditor

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)

    File.open(file).each do |line|
      line = line.chomp
      case line
      when 'S'
          puts "There is no image"
      else
          puts 'unrecognised command :('
      end
    end
  end

  def create_table(row:, col:)
    raise Exceptions::ValidationError.new('Please make sure your rows >= 1 and cols >= 1') unless row >= 1 && col >= 1

    Matrix.zero(row, col)
  end

  def clear_table(matrix)
    raise Exceptions::ValidationError.new('Please make sure your input is Matrix') unless matrix.is_a?(Matrix)

    Matrix.zero(matrix.row_count, matrix.column_count)
  end

  def draw_pixel(matrix:, row:, col:, color:)
    raise Exceptions::ValidationError.new('Please make sure your input is Matrix') unless matrix.is_a?(Matrix)
    raise Exceptions::ValidationError.new('No color is given') unless color
    raise Exceptions::ValidationError.new('Please make sure your rows >= 1 and cols >= 1') unless row >= 1 && col >= 1
    raise Exceptions::ValidationError.new("#{ 'row is invalid' if row > matrix.row_count} + #{ 'col is invalid' if col > matrix.column_count}") unless row <= matrix.row_count && col <= matrix.column_count

    MatrixUtil.set_element(matrix, row, col, color)
  end

  def draw_column(matrix: , col: , row_start: , row_end: , color: )
    raise Exceptions::ValidationError.new('Please make sure your input is Matrix') unless matrix.is_a?(Matrix)
    raise Exceptions::ValidationError.new('No color is given') unless color
    raise Exceptions::ValidationError.new('Please make sure your rows >= 1 and cols >= 1') unless row_start >= 1 && col >= 1
    raise Exceptions::ValidationError.new("#{ 'row is invalid' if row_end > matrix.row_count} + #{ 'col is invalid' if col > matrix.column_count}") unless row_end <= matrix.row_count && col <= matrix.column_count

    MatrixUtil.set_col(matrix, col, row_start, row_end, color)
  end

  def draw_row(matrix: , row: , col_start: , col_end: , color: )
    raise Exceptions::ValidationError.new('Please make sure your input is Matrix') unless matrix.is_a?(Matrix)
    raise Exceptions::ValidationError.new('No color is given') unless color
    raise Exceptions::ValidationError.new('Please make sure your rows >= 1 and cols >= 1') unless row >= 1 && col_start >= 1
    raise Exceptions::ValidationError.new("#{ 'row is invalid' if row > matrix.row_count} + #{ 'col is invalid' if col_end > matrix.column_count}") unless row <= matrix.row_count && col_end <= matrix.column_count

    MatrixUtil.set_row(matrix, row, col_start, col_end, color)
  end
end
