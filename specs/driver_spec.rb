require_relative 'spec_helper'

describe "RideShare::Driver" do
  let(:all_trips) { RideShare::Trip.all }
  let(:all_riders) { RideShare::Rider.all }
  let(:all_drivers) { RideShare::Driver.all }
  let(:example_driver) { RideShare::Driver.new(id: "9", name: "Simone Hackett", vin: "4RA34A5K3YPN8H5P4") }
  # initialize .all for each class--as default dataset
  before do
    all_trips
    all_riders
    all_drivers
  end

  describe "Driver#initialize" do
    it "creates a Driver instance" do
      example_driver.must_be_instance_of RideShare::Driver
    end

    it "passes in Driver data with keys" do
      #9,Simone Hackett,4RA34A5K3YPN8H5P4
      example_driver.must_respond_to :id
      example_driver.must_respond_to :name
      example_driver.must_respond_to :vin
      example_driver.id.must_equal 9
      example_driver.name.must_equal "Simone Hackett"
      example_driver.vin.must_equal "4RA34A5K3YPN8H5P4"
    end

    # EDGE CASE
    it "prints message when passed invalid vin" do
      proc {
        RideShare::Driver.new(id: "9", name: "Simone Hackett", vin: "4RA34A5K3YPN8H5P40000000")
      }.must_output("Invalid VIN: Driver_9.\n")
    end

    # EDGE CASE
    it "prints message when passed no vin" do
      proc {
        RideShare::Driver.new(id: "9", name: "Simone Hackett")
      }.must_output("Missing VIN: Driver_9.\n")
    end

    it "is silent when passed good vin" do
      proc {
        example_driver
      }.must_be_silent
    end

    it "can initialize with missing data" do
      no_vin_driver = RideShare::Driver.new(id: "87", name: "Tamiko Terada")
      no_vin_driver.must_be_instance_of RideShare::Driver
      no_vin_driver.vin.must_be_nil
    end
  end

  describe "Driver#all" do
    it "returns an array" do
      all_drivers.must_be_kind_of Array
    end

    it "each returned element is a Driver instance" do
      all_drivers.each do |each_driver|
        each_driver.must_be_instance_of RideShare::Driver
      end
    end

    it "returns the correct number of elements" do
      all_drivers.length.must_equal 100 # rows in CSV file
    end

    # EDGE CASE
    it "correctly reads in the first row of the CSV file" do
      # last row of data: 1,Bernardo Prosacco,WBWSS52P9NEYLVDE9
      all_drivers[0].id.must_equal 1
      all_drivers[0].name.must_equal "Bernardo Prosacco"
      all_drivers[0].vin.must_equal "WBWSS52P9NEYLVDE9"
    end

    # EDGE CASE
    it "correctly reads in the last row of the CSV file" do
      # last row of data: 100,Minnie Dach,XF9Z0ST7X18WD41HT
      all_drivers[-1].id.must_equal 100
      all_drivers[-1].name.must_equal "Minnie Dach"
      all_drivers[-1].vin.must_equal "XF9Z0ST7X18WD41HT"
    end
  end

  describe "Driver#Trips" do
    let (:example_driver_trips) { example_driver.trips }

    it "returns value as an Array" do
      example_driver_trips.must_be_kind_of Array
    end

    it "first Trip is associated with the expected driver" do
      example_driver_trips[0].must_be_instance_of RideShare::Trip
      example_driver_trips[0].driver_id.must_equal 9
    end

    it "last Trip is associated with the expected driver" do
      example_driver_trips[0].must_be_instance_of RideShare::Trip
      example_driver_trips[-1].driver_id.must_equal 9
    end
  end

  describe "Driver#avg_rating" do
    let (:example_driver_avg) { example_driver.avg_rating }

    it "returns value as a Float" do
      example_driver_avg.must_be_kind_of Float
    end

    it "return value is between 0 and 5" do
      example_driver_avg.must_be :<=, 5
      example_driver_avg.must_be :>=, 0
    end

    # EDGE CASE
    it "rounds to two decimal points correctly" do
      driver_21 = RideShare::Driver.find(21)
      driver_21.avg_rating.must_equal 2.73
      # manually calculated as 30/11 = 2.73 rounded
    end
  end

  describe "Driver#find" do
    let(:driver_found) { RideShare::Driver.find(31) }

    it "return value is a Driver instance" do
      driver_found.must_be_instance_of RideShare::Driver
    end

    it "finds the correct instance of Driver" do
      driver_found.id.must_equal 31
      driver_found.name.must_equal "Sheila VonRueden"
      driver_found.vin.must_equal "KPH9RLSZ9YKNVMGH2"
    end

    # EDGE CASE
    it "returns nil for a nonexistent Driver" do
      nonexistent = RideShare::Driver.find(999)
      nonexistent.must_be_nil
    end

    # EDGE CASE
    it "prints message with a failed search" do
      proc {
        RideShare::Driver.find(999)
      }.must_output puts "Driver_999 not found."
    end
  end
end
