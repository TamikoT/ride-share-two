require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'

require_relative '../lib/driver'

describe "RideShare::Trip" do

  before do
    #9,Simone Hackett,4RA34A5K3YPN8H5P4
    @driver = RideShare::Trip.new({id: "9", name: "Simone Hackett", vin: "4RA34A5K3YPN8H5P4"})
  end

  describe "Trip#initialize" do
    it "creates a new instance of trip" do
      @driver.must_be_instance_of RideShare::Driver
    end
    it "passes in the driver name" do
      @driver.id.must_equal 9
    end
    it "passes in the vin" do
      @driver.name.must_equal "Simone Hackett"
    end
    it "passes in the rider_id" do
      @driver.vin.must_equal "4RA34A5K3YPN8H5P4"
    end
    it "can create a new driver with a missing vin" do
      no_vin = RideShare::Trip.new({id: "87", name: "Tamiko Terada"})
      no_vin.vin.must_equal nil
    end
  end
end
