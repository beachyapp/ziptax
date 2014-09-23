module ZipTax
  class << self
    attr_accessor :api_key
  end
end

require "zip_tax/version"
require_relative 'zip_tax/sales_tax'
require_relative 'zip_tax/response'
require_relative 'zip_tax/result'
