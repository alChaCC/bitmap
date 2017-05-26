require 'spec_helper'

RSpec.describe 'BitmapEditor' do
  let(:bitmap_editor) { BitmapEditor.new }
  let(:matrix) { Matrix.rows([['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O']]) }

  describe 'I M N - Clears the table, setting all pixels to white (O).' do
    it 'I 5 6' do
      expect(bitmap_editor.create_table(row: 6, col: 5)).to eq(matrix)
    end

    it 'raise Exceptions::ValidationError if rows < 1' do
      expect { bitmap_editor.create_table(row: 0, col: 5) }.to raise_error(Exceptions::ValidationError)
    end
  end

  describe 'C - Clears the table, setting all pixels to white (O).' do
    it 'C' do
      updated_matrix = Matrix.rows([['A', 'O', 'A', 'O', 'A'], ['O', 'A', 'O', 'A', 'O'], ['A', 'A', 'A', 'A', 'A'], ['O', 'O', 'O', 'O', 'O'], ['A', 'A', 'A', 'O', 'O'], ['O', 'O', 'O', 'A', 'A']])
      expect(bitmap_editor.clear_table(updated_matrix)).to eq(matrix)
    end

    it 'raise Exceptions::ValidationError if input is not Matrix' do
      expect { bitmap_editor.clear_table(['hello']) }.to raise_error(Exceptions::ValidationError)
    end
  end

  describe 'L X Y C - Colours the pixel (X,Y) with colour C.' do
    it 'L 1 3 A' do
      expect(bitmap_editor.draw_pixel(matrix: matrix, row: 3, col: 1, color: 'A')).to eq(Matrix.rows([['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O'], ["A", 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O']]))
    end

    context 'raise Exceptions::ValidationError' do
      it 'when input is not Matrix' do
        expect { bitmap_editor.draw_pixel(matrix: [], row: 3, col: 1, color: 'A') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when col < 1' do
        expect { bitmap_editor.draw_pixel(matrix: matrix, row: 3, col: 0, color: 'A') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when color is nil' do
        expect { bitmap_editor.draw_pixel(matrix: matrix, row: 3, col: 1, color: nil) }.to raise_error(Exceptions::ValidationError)
      end

      it 'when color is not string' do
        expect { bitmap_editor.draw_pixel(matrix: matrix, row: 3, col: 1, color: 1) }.to raise_error(Exceptions::ValidationError)
      end

      it 'X > col_num' do
        expect { bitmap_editor.draw_pixel(matrix: matrix, row: 7, col: 1, color: 'A') }.to raise_error(Exceptions::ValidationError)
      end

      it 'color is not capital' do
        expect { bitmap_editor.draw_pixel(matrix: matrix, row: 3, col: 1, color: 'a') }.to raise_error(Exceptions::ValidationError)
      end
    end
  end

  describe 'V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).' do
    it 'V 2 3 6 W' do
      expect(bitmap_editor.draw_column(matrix: matrix, col: 2, row_start: 3, row_end: 6, color: 'W')).to eq(Matrix.rows([['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O'], ['O', "W", 'O', 'O', 'O'], ['O', "W", 'O', 'O', 'O'], ['O', "W", 'O', 'O', 'O'], ['O', "W", 'O', 'O', 'O']]))
    end

    context 'raise Exceptions::ValidationError' do
      it 'when input is not Matrix' do
        expect { bitmap_editor.draw_column(matrix: [], col: 2, row_start: 3, row_end: 6, color: 'W') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when row_start < 1' do
        expect { bitmap_editor.draw_column(matrix: matrix, col: 2, row_start: 0, row_end: 6, color: 'W') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when row_end > 6' do
        expect { bitmap_editor.draw_column(matrix: matrix, col: 2, row_start: 3, row_end: 7, color: 'W') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when color is nil' do
        expect { bitmap_editor.draw_column(matrix: matrix, col: 2, row_start: 3, row_end: 6, color: nil) }.to raise_error(Exceptions::ValidationError)
      end

      it 'X > col_num' do
        expect { bitmap_editor.draw_column(matrix: matrix, col: 6, row_start: 3, row_end: 6, color: 'W') }.to raise_error(Exceptions::ValidationError)
      end
    end
  end

  describe 'H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).' do
    it 'H 3 5 2 Z' do
      expect(bitmap_editor.draw_row(matrix: matrix, row: 2, col_start: 3, col_end: 5, color: 'Z')).to eq(Matrix.rows([['O', 'O', 'O', 'O', 'O'], ['O', 'O', "Z", "Z", "Z"], ['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O']]))
    end

    context 'raise Exceptions::ValidationError' do
      it 'when input is not Matrix' do
        expect { bitmap_editor.draw_row(matrix: '', row: 2, col_start: 3, col_end: 5, color: 'Z') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when col_start < 1' do
        expect { bitmap_editor.draw_row(matrix: matrix, row: 2, col_start: 0, col_end: 5, color: 'Z') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when col_end > 5' do
        expect { bitmap_editor.draw_row(matrix: matrix, row: 2, col_start: 3, col_end: 6, color: 'Z') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when color is nil' do
        expect { bitmap_editor.draw_row(matrix: matrix, row: 2, col_start: 3, col_end: 5, color: nil) }.to raise_error(Exceptions::ValidationError)
      end

      it 'Y > row_num' do
        expect { bitmap_editor.draw_row(matrix: matrix, row: 7, col_start: 3, col_end: 5, color: 'Z') }.to raise_error(Exceptions::ValidationError)
      end
    end
  end

  describe 'S - Show the contents of the current image' do
    it 'S' do
      updated_matrix = Matrix.rows([['A', 'O', 'A', 'O', 'A'], ['O', 'A', 'O', 'A', 'O'], ['A', 'A', 'A', 'A', 'A'], ['O', 'O', 'O', 'O', 'O'], ['A', 'A', 'A', 'O', 'O'], ['O', 'O', 'O', 'A', 'A']])
      expect { bitmap_editor.show_table(updated_matrix) }.to output("AOAOA\nOAOAO\nAAAAA\nOOOOO\nAAAOO\nOOOAA\n").to_stdout
    end
  end

  describe 'Run' do
    let(:current_path) { Dir.pwd }

    it 'normal case' do
      expect { bitmap_editor.run(current_path + '/examples/show.txt') }.to output("OOAOO\nOOZZZ\nOWOOO\nOWOOO\nOWOOO\nOWOOO\n").to_stdout
    end

    it 'normal case - complex' do
      expected_string = <<-DOC
OOAOO
OOZZZ
OWOOO
OWOOO
OWOOO
OWOOO
OOOOO
OOOOO
OOOOO
OOOOO
OOOOO
OOOOO
OV
OO
VO
OO
OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
OOSSOOOOOOSSSOOOOOOSSSSSSSSSSSOOOOO
OOSSOOOOOOSSSOOOOOOSSSSSSSSSSSOOOOO
OOSSOOOOOOSSSOOOOOOOOOOSSSOOOOOOOOO
OOSSSSSSSSSSSOOOOOOOOOOSSSOOOOOOOOO
OOSSSSSSSSSSSOOOOOOOOOOSSSOOOOOOOOO
OOSSOOOOOOSSSOOOOOOOOOOSSSOOOOOOOOO
OOSSOOOOOOSSSOOOOOOSSSSSSSSSSSOOOOO
OOSSOOOOOOSSSOOOOOOSSSSSSSSSSSOOOOO
OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
      DOC
      expect { bitmap_editor.run(current_path + '/examples/show-complex.txt') }.to output(expected_string).to_stdout
    end

    it 'error cases' do
      expected_string = <<-DOC
Line2-ValidationError:No Image is initialized
      DOC
      expect { bitmap_editor.run(current_path + '/examples/errors.txt') }.to output(expected_string).to_stdout
    end
  end
end
