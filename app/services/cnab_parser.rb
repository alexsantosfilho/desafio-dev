class CnabParserService
  def initialize(file_path)
    @file_path = file_path
  end

  def call
    transactions = []
    File.open(@file_path, "r") do |file|
      file.each_line do |line|
        transactions << parse_line(line)
      end
    end
    transactions
  end

  private

  def parse_line(line)
    {
      transaction_type: line[0].to_i,
      date: parse_date(line[1..8]),
      value: line[9..18].to_f / 100.0,
      cpf: line[19..29],
      card: line[30..41],
      hour: parse_time(line[42..47]),
      store_owner: line[48..61].strip,
      store_name: line[62..80].strip
    }
  end

  def parse_date(date_str)
    Date.strptime(date_str, "%Y%m%d")
  end

  def parse_time(time_str)
    Time.strptime(time_str, "%H%M%S")
  end
end
