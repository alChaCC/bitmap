require 'spec_helper'

RSpec.describe 'BitmapEditor' do
  let(:bitmap_editor) { BitmapEditor.new }
  let(:matrix) { Matrix.rows([[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]) }

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
      expect(bitmap_editor.clear_table(updated_matrix)).to eq(matrix)
    end

    it 'raise Exceptions::ValidationError if input is not Matrix' do
      expect { bitmap_editor.clear_table(['hello']) }.to raise_error(Exceptions::ValidationError)
    end
  end

  describe 'L X Y C - Colours the pixel (X,Y) with colour C.' do
    it 'L 1 3 A' do
      expect(bitmap_editor.draw_pixel(matrix: matrix, row: 3, col: 1, color: 'A')).to eq(Matrix.rows([[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], ["A", 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]))
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

      it 'X > col_num' do
        expect { bitmap_editor.draw_pixel(matrix: matrix, row: 7, col: 1, color: 'A') }.to raise_error(Exceptions::ValidationError)
      end
    end
  end
end
