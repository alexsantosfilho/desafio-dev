class ImportTransaction < ApplicationRecord
  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }

  validates :file_name, presence: true
end
