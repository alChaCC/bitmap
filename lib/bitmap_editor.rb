require_relative 'exceptions'
require_relative 'matrix_util'
require 'Matrix'
require 'pry'

class BitmapEditor

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)
    matrix = nil
    File.open(file).each_with_index do |line, index|
      begin
        line = line.chomp.split(' ')
        case line.first
        when 'I', 'i'
          matrix = create_table(row: line[2].to_i, col: line[1].to_i)
        when 'C', 'c'
          matrix = clear_table(matrix)
        when 'L', 'l'
          matrix = draw_pixel(matrix: matrix, row: line[2].to_i, col: line[1].to_i, color: line[3])
        when 'V', 'v'
          matrix = draw_column(matrix: matrix, col: line[1].to_i, row_start: line[2].to_i, row_end: line[3].to_i, color: line[4])
        when 'H', 'h'
          matrix = draw_row(matrix: matrix, row: line[3].to_i, col_start: line[1].to_i, col_end: line[2].to_i, color: line[4])
        when 'S', 's'
          show_table(matrix)
        else
          puts line.join
        end
      rescue Exceptions::ValidationError => e
        puts "Line#{index+1}-" + e.instance_variable_get(:@title) + ':' + e.message
      rescue
        puts "Something wrong...."
      end
    end
  end

  def create_table(row:, col:)
    raise Exceptions::ValidationError.new('Please make sure your rows >= 1 and cols >= 1') unless row >= 1 && col >= 1

    Matrix.zero(row, col)
  end

  def clear_table(matrix)
    check_is_matrix(matrix)

    Matrix.zero(matrix.row_count, matrix.column_count)
  end

  def draw_pixel(matrix:, row:, col:, color:)
    draw(matrix, row, row, col, col, color) do
      MatrixUtil.set_element(matrix, row, col, color)
    end
  end

  def draw_column(matrix: , col: , row_start: , row_end: , color: )
    draw(matrix, row_start, row_end, col, col, color) do
      MatrixUtil.set_col(matrix, col, row_start, row_end, color)
    end
  end

  def draw_row(matrix: , row: , col_start: , col_end: , color: )
    draw(matrix, row, row, col_start, col_end, color) do
      MatrixUtil.set_row(matrix, row, col_start, col_end, color)
    end
  end

  def show_table(matrix)
    check_is_matrix(matrix)

    matrix.to_a.each { |a| puts a.join }
  end


  private

  def draw(matrix, row_start, row_end, col_start, col_end, color, &block)
    check_is_matrix(matrix)
    check_color(color)
    check_row_and_col(matrix, row_start, row_end, col_start, col_end)

    block.call
  end

  def check_row_and_col(matrix, row_start, row_end, col_start, col_end)
    raise Exceptions::ValidationError.new('Please make sure your rows >= 1 and cols >= 1') unless row_start >= 1 && col_start >= 1
    raise Exceptions::ValidationError.new("#{ 'row is invalid' if row_end > matrix.row_count}" + "#{ 'col is invalid' if col_end > matrix.column_count}") unless row_end <= matrix.row_count && col_end <= matrix.column_count
  end

  def check_is_matrix(matrix)
    raise Exceptions::ValidationError.new('No Image is initialized') unless matrix.is_a?(Matrix)
  end

  def check_color(color)
    raise Exceptions::ValidationError.new('No color is given') unless color
  end
end
