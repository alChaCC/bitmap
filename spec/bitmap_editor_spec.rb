require 'spec_helper'

RSpec.describe 'BitmapEditor' do
  let(:matrix) { Matrix.rows([[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]) }
  let(:bitmap_editor) { BitmapEditor.new(matrix) }

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
      updated_matrix = Matrix.rows([[1, 0, 1, 0, 1], [0, 1, 0, 1, 0], [1, 1, 1, 1, 1], [0, 0, 0, 0, 0], [1, 1, 1, 0, 0], [0, 0, 0, 1, 1]])
      bitmap_editor  = BitmapEditor.new(updated_matrix)
      expect(bitmap_editor.clear_table).to eq(matrix)
    end

    it 'raise Exceptions::ValidationError if input is not Matrix' do
      bitmap_editor.matrix = []
      expect { bitmap_editor.clear_table }.to raise_error(Exceptions::ValidationError)
    end
  end

  describe 'L X Y C - Colours the pixel (X,Y) with colour C.' do
    it 'L 1 3 A' do
      expect(bitmap_editor.draw_pixel(row: 3, col: 1, color: 'A')).to eq(Matrix.rows([[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], ["A", 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]))
    end

    context 'raise Exceptions::ValidationError' do
      it 'when input is not Matrix' do
        bitmap_editor.matrix = []
        expect { bitmap_editor.draw_pixel(row: 3, col: 1, color: 'A') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when col < 1' do
        expect { bitmap_editor.draw_pixel(row: 3, col: 0, color: 'A') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when color is nil' do
        expect { bitmap_editor.draw_pixel(row: 3, col: 1, color: nil) }.to raise_error(Exceptions::ValidationError)
      end

      it 'X > col_num' do
        expect { bitmap_editor.draw_pixel(row: 7, col: 1, color: 'A') }.to raise_error(Exceptions::ValidationError)
      end
    end
  end

  describe 'V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).' do
    it 'V 2 3 6 W' do
      expect(bitmap_editor.draw_column(col: 2, row_start: 3, row_end: 6, color: 'W')).to eq(Matrix.rows([[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, "W", 0, 0, 0], [0, "W", 0, 0, 0], [0, "W", 0, 0, 0], [0, "W", 0, 0, 0]]))
    end

    context 'raise Exceptions::ValidationError' do
      it 'when input is not Matrix' do
        bitmap_editor.matrix = []
        expect { bitmap_editor.draw_column(col: 2, row_start: 3, row_end: 6, color: 'W') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when row_start < 1' do
        expect { bitmap_editor.draw_column(col: 2, row_start: 0, row_end: 6, color: 'W') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when row_end > 6' do
        expect { bitmap_editor.draw_column(col: 2, row_start: 3, row_end: 7, color: 'W') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when color is nil' do
        expect { bitmap_editor.draw_column(col: 2, row_start: 3, row_end: 6, color: nil) }.to raise_error(Exceptions::ValidationError)
      end

      it 'X > col_num' do
        expect { bitmap_editor.draw_column(col: 6, row_start: 3, row_end: 6, color: 'W') }.to raise_error(Exceptions::ValidationError)
      end
    end
  end

  describe 'H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).' do
    it 'H 3 5 2 Z' do
      expect(bitmap_editor.draw_row(row: 2, col_start: 3, col_end: 5, color: 'Z')).to eq(Matrix.rows([[0, 0, 0, 0, 0], [0, 0, "Z", "Z", "Z"], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]))
    end

    context 'raise Exceptions::ValidationError' do
      it 'when input is not Matrix' do
        bitmap_editor.matrix = ''
        expect { bitmap_editor.draw_row(row: 2, col_start: 3, col_end: 5, color: 'Z') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when col_start < 1' do
        expect { bitmap_editor.draw_row(row: 2, col_start: 0, col_end: 5, color: 'Z') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when col_end > 5' do
        expect { bitmap_editor.draw_row(row: 2, col_start: 3, col_end: 6, color: 'Z') }.to raise_error(Exceptions::ValidationError)
      end

      it 'when color is nil' do
        expect { bitmap_editor.draw_row(row: 2, col_start: 3, col_end: 5, color: nil) }.to raise_error(Exceptions::ValidationError)
      end

      it 'Y > row_num' do
        expect { bitmap_editor.draw_row(row: 7, col_start: 3, col_end: 5, color: 'Z') }.to raise_error(Exceptions::ValidationError)
      end
    end
  end

  describe 'S - Show the contents of the current image' do
    it 'S' do
      updated_matrix = Matrix.rows([[1, 0, 1, 0, 1], [0, 1, 0, 1, 0], [1, 1, 1, 1, 1], [0, 0, 0, 0, 0], [1, 1, 1, 0, 0], [0, 0, 0, 1, 1]])
      bitmap_editor.matrix = updated_matrix
      expect { bitmap_editor.show_table }.to output("10101\n01010\n11111\n00000\n11100\n00011\n").to_stdout
    end
  end

  describe 'Run' do
    let(:current_path) { Dir.pwd }

    it 'normal case' do
      expect { bitmap_editor.run(current_path + '/examples/show.txt') }.to output("00000\n00ZZZ\nAW000\n0W000\n0W000\n0W000\n").to_stdout
    end

    it 'normal case - complex' do
      expected_string = <<-DOC
00000
00ZZZ
AW000
0W000
0W000
0W000
00000
00000
00000
00000
00000
00000
0V
00
V0
00
00000000000000000000000000000000000
0SSS000000SSS000000SSSSSSSSSSS00000
0SSS000000SSS000000SSSSSSSSSSS00000
0SSS000000SSS0000000000SSS000000000
0SSSSSSSSSSSS0000000000SSS000000000
0SSSSSSSSSSSS0000000000SSS000000000
0SSS000000SSS0000000000SSS000000000
0SSS000000SSS000000SSSSSSSSSSS00000
0SSS000000SSS000000SSSSSSSSSSS00000
00000000000000000000000000000000000
      DOC
      expect { bitmap_editor.run(current_path + '/examples/show-complex.txt') }.to output(expected_string).to_stdout
    end

    it 'error cases' do
      expected_string = <<-DOC
#NO_Image
Line2-ValidationError:No Image is initialized
Line3-ValidationError:No Image is initialized
Line4-ValidationError:No Image is initialized
Line5-ValidationError:No Image is initialized
Line6-ValidationError:No Image is initialized
#Pixel(6,6)>col_number
Line9-ValidationError:col is invalid
00000
00ZZZ
AW000
0W000
0W000
0W000
#DrawCol:6>col_number
Line18-ValidationError:col is invalid
00000
00ZZZ
A0000
00000
00000
00000
#DrawRow:7>row_number
Line26-ValidationError:row is invalid
00000
00000
AW000
0W000
0W000
0W000
      DOC
      bitmap_editor.matrix = nil
      expect { bitmap_editor.run(current_path + '/examples/errors.txt') }.to output(expected_string).to_stdout
    end
  end
end
