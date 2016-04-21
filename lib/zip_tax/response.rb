module ZipTax
  class Response < OpenStruct

    def success?
      self.rCode && self.rCode == 100
    end

    def self.new_from_http_request(response_hsh)
      JSON.parse(response_hsh)
    end

    def self.create_result_from_response(result)
      ZipTax::Result.new(result)
    end
  end
end
