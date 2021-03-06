require_relative 'transaction'
require_relative 'repository'
require_relative 'finders/invoice_id_finder'

class TransactionRepository < Repository
  include InvoiceIDFinder
  attr_reader :sales_engine
  attr_accessor :data

  def initialize(entries, sales_engine)
    @sales_engine = sales_engine
    @data ||= entries.map { |entry| Transaction.new(entry, self) }
  end

  def find_by_credit_card_number(credit_card_number)
    find_by :credit_card_number, credit_card_number
  end

  def find_by_credit_card_expiration_date(credit_card_expiration_date)
    find_by :credit_card_expiration_date, credit_card_expiration_date
  end

  def find_by_result(result)
    find_by :result, result
  end

  def find_all_by_credit_card_number(credit_card_number)
    find_all_by :credit_card_number, credit_card_number
  end

  def find_all_by_credit_card_expiration_date(credit_card_expiration_date)
    find_all_by :credit_card_expiration_date, credit_card_expiration_date
  end

  def find_all_by_result(result)
    find_all_by :result, result
  end

  def find_invoice_from(id)
    sales_engine.find_invoice_from_transaction(id)
  end

  def add(credit_card_number, credit_card_exp, result, invoice_id)
    new_trans = {
      :id                          => next_id,
      :invoice_id                  => invoice_id,
      :credit_card_number          => credit_card_number,
      :credit_card_expiration_date => credit_card_exp,
      :result                      => result,
      :created_at                  => Date.today.to_s,
      :updated_at                  => Date.today.to_s
    }
    self.data << Transaction.new(new_trans, self)
    data.last
  end

  def next_id
    data.max_by { |trans| trans.id }.id + 1
  end
end
