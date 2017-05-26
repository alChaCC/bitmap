require_relative 'exceptions'
require_relative 'matrix_util'
require 'Matrix'
require 'pry'

class BitmapEditor
# Class to create bitmap

  # Method to parse file and show bitmap
  #
  # @param file [String] file path
  # @return [void]
  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)
    matrix = nil
    File.open(file).each_with_index do |line, index|
      begin
        line = line.chomp.split(' ')
        case line.first
        when 'I'
          matrix = create_table(row: line[2].to_i, col: line[1].to_i)
        when 'C'
          matrix = clear_table(matrix)
        when 'L'
          matrix = draw_pixel(matrix: matrix, row: line[1].to_i, col: line[2].to_i, color: line[3])
        when 'V'
          matrix = draw_column(matrix: matrix, col: line[1].to_i, row_start: line[2].to_i, row_end: line[3].to_i, color: line[4])
        when 'H'
          matrix = draw_row(matrix: matrix, row: line[3].to_i, col_start: line[1].to_i, col_end: line[2].to_i, color: line[4])
        when 'S'
          show_table(matrix)
        else
          Exceptions::ValidationError.new('Unrecognized Input')
        end
      rescue Exceptions::ValidationError => e
        puts "Line#{index+1}-" + e.instance_variable_get(:@title) + ':' + e.message
        return
      rescue => e
        puts "Something wrong...."
        return
      end
    end
  end

  # Method to create an empty Matrix
  #
  # @param row [Integer] matrix's row size
  # @param col [Integer] matrix's column size
  # @return [Matrix]
  def create_table(row:, col:)
    raise Exceptions::ValidationError.new('Please make sure your rows <= 250 and cols <= 250') unless row <= 250 && col <= 250
    raise Exceptions::ValidationError.new('Please make sure your rows >= 1 and cols >= 1') unless row >= 1 && col >= 1

    Matrix.build(row, col) { 'O' }
  end

  # Method to clear an existing Matrix
  # setting all pixels to white (O)
  #
  # @param matrix [Matrix] a Matrix object
  # @return [Matrix]
  def clear_table(matrix)
    check_is_matrix(matrix)

    Matrix.build(matrix.row_count, matrix.column_count) { 'O' }
  end

  # Method to draw the pixel (X,Y) with colour C
  #
  # @param matrix [Matrix]  a Matrix object
  # @param row [Integer]  row position
  # @param col [Integer] column position
  # @param color [String, Integer] the color you want to draw
  # @return [Matrix]
  def draw_pixel(matrix:, row:, col:, color:)
    draw(matrix, row, row, col, col, color) do
      MatrixUtil.set_element(matrix, row, col, color)
    end
  end

  # Method to draw a vertical segment of colour C
  # in column X between rows Y1 and Y2 (inclusive).
  #
  # @param matrix [Matrix] a Matrix object
  # @param col [Integer] column position
  # @param row_start [Integer] row start position
  # @param row_end [Integer] row end position
  # @param color [String, Integer] the color you want to draw
  # @return [Matrix]
  def draw_column(matrix: , col: , row_start: , row_end: , color: )
    draw(matrix, row_start, row_end, col, col, color) do
      MatrixUtil.set_col(matrix, col, row_start, row_end, color)
    end
  end

  # Method to draw a horizontal segment of colour C
  # in row Y between columns X1 and X2 (inclusive).
  #
  # @param matrix [Matrix] a Matrix object
  # @param row [Integer] row position
  # @param col_start [Integer] col start position
  # @param col_end [Integer] col end position
  # @param color [String, Integer] the color you want to draw
  # @return [Matrix]
  def draw_row(matrix: , row: , col_start: , col_end: , color: )
    draw(matrix, row, row, col_start, col_end, color) do
      MatrixUtil.set_row(matrix, row, col_start, col_end, color)
    end
  end

  # Method to show the contents of the current image
  #
  # @param matrix [Matrix] a Matrix object
  # @return [Matrix]
  def show_table(matrix)
    check_is_matrix(matrix)

    matrix.to_a.each { |a| puts a.join }
  end


  private

  # Method to draw
  #
  # @param matrix [Matrix] a Matrix object
  # @param row_start [Integer] row start position
  # @param row_end [Integer] row end position
  # @param col_start [Integer] col start position
  # @param col_end [Integer] col end position
  # @param color [String, Integer] the color you want to draw
  # @return [Matrix]
  def draw(matrix, row_start, row_end, col_start, col_end, color, &block)
    check_is_matrix(matrix)
    check_color(color)
    check_row_and_col(matrix, row_start, row_end, col_start, col_end)

    block.call
  end

  # Method to check row and col
  #
  # @param matrix [Matrix] a Matrix object
  # @param row_start [Integer] row start position
  # @param row_end [Integer] row end position
  # @param col_start [Integer] col start position
  # @param col_end [Integer] col end position
  # @raise [Exceptions::ValidationError] validation fail
  # @return [void]
  def check_row_and_col(matrix, row_start, row_end, col_start, col_end)
    raise Exceptions::ValidationError.new('Please make sure your rows <= 250 and cols <= 250') unless row_end <= 250 && col_end <= 250
    raise Exceptions::ValidationError.new('Please make sure your rows >= 1 and cols >= 1') unless row_start >= 1 && col_start >= 1
    raise Exceptions::ValidationError.new("#{ 'row is invalid' if row_end > matrix.row_count}" + "#{ 'col is invalid' if col_end > matrix.column_count}") unless row_end <= matrix.row_count && col_end <= matrix.column_count
  end

  # Method to check input is a Matrix
  #
  # @param matrix [Matrix] a Matrix object
  # @raise [Exceptions::ValidationError] validation fail
  # @return [void]
  def check_is_matrix(matrix)
    raise Exceptions::ValidationError.new('No Image is initialized') unless matrix.is_a?(Matrix)
  end

  # Method to check color is a Matrix
  #
  # @param color [String, Integer] the color you want to check
  # @raise [Exceptions::ValidationError] validation fail
  # @return [void]
  def check_color(color)
    raise Exceptions::ValidationError.new('No color is given') unless color
    raise Exceptions::ValidationError.new('Color must be a String') unless color.is_a?(String)
    raise Exceptions::ValidationError.new('Color must be capital letters') unless color == color.upcase
  end
end
