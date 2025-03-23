require 'rails_helper'

RSpec.describe CnabImporter do
  let(:file) { fixture_file_upload('spec/fixtures/files/CNAB.txt', 'text/plain') }

  describe '#call' do
    it 'imports the file successfully' do
      importer = described_class.new(file)
      expect { importer.call }.to change(ImportTransaction, :count).by(1)
    end

    it 'raises an error for invalid file type' do
      invalid_file = fixture_file_upload('spec/fixtures/files/image.png', 'image/png')
      importer = described_class.new(invalid_file)
      expect { importer.call }.to raise_error("Por favor, selecione um arquivo .txt válido.")
    end
  end
end
