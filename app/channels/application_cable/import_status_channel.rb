class ImportStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "import_status"
  end
end
