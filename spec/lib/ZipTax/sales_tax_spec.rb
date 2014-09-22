require 'spec_helper'

describe ZipTax::SalesTax do
  let(:fake_response) {
    <<-STR
    {
      "version": "v20",
      "rCode": 100,
      "results": [
        {
        "geoPostalCode": "10801",
        "geoCity": "NEW ROCHELLE",
        "geoCounty": "WESTCHESTER",
        "geoState": "NY",
        "taxSales": 0.083750002086163,
        "taxUse": 0.083750002086163,
        "txbService": "L",
        "txbFreight": "Y",
        "stateSalesTax": 0.03999999910593,
        "stateUseTax": 0.03999999910593,
        "citySalesTax": 0.03999999910593,
        "cityUseTax": 0.03999999910593,
        "cityTaxCode": "NE 6861",
        "countySalesTax": 0,
        "countyUseTax": 0,
        "countyTaxCode": "WE 5581",
        "districtSalesTax": 0.003749999916181,
        "districtUseTax": 0.003749999916181
        }
       ]
      }
    STR
  }
  describe "#new" do
    #TODO: don't support xml
    it "errors if key or postal code are not set" do
     expect {
       ZipTax::SalesTax.new(postal_code: '001245')
     }.to raise_exception(ArgumentError, /api key/i)

     expect {
       ZipTax::SalesTax.new(key: 'abc123')
     }.to raise_exception(ArgumentError, /postal_code/i)
    end

    it "sets all possible parameters to the api" do
      rq = ZipTax::SalesTax.new(key: 'abc123',
                                postal_code: '000123',
                                state: 'NY',
                                city: 'New York',
                                format: 'json')
      expect(rq).to be_kind_of ZipTax::SalesTax
      [:key, :postal_code, :state, :city, :format].each do |attr|
        expect(rq.send(attr.to_sym)).to_not be_nil
      end
    end
  end

  describe "#request_tax" do
    context "success" do
      it "returns a json response" do
        fake_http = OpenStruct.new
        fake_http.body = fake_response
        expect(Net::HTTP).to receive(:get).and_return(fake_http)
        rq = ZipTax::SalesTax.new(key: 'abc123', postal_code: 000123)
        resp = rq.request_tax
        expect(resp).to be_kind_of ZipTax::Response
      end
    end
  end

  describe "#request_url" do
    it "includes the keys/values included as get params on the base url" do
      rq = ZipTax::SalesTax.new(key: 'abc123', postal_code: "00012")
      expect(rq.request_url).to eql("#{ZipTax::SalesTax::BASE_URL}?key=abc123&postal_code=00012&state&city&format=json")
    end
  end
  describe ".request_for" do
  end
end
