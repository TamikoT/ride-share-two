require 'csv'

# new Trip class, subclass of RideShare
module RideShare
  class Trip
    attr_reader :id, :driver_id, :rider_id, :date, :rating, :all

    # take in id, driver_id, rider_id, date, rating as a hash
    def initialize(trip_info={})
      @id = trip_info[:id].to_i
      @driver_id = trip_info[:driver_id].to_i
      @rider_id = trip_info[:rider_id].to_i
      @date = trip_info[:date]
      @rating = trip_info[:rating].to_f
    end

    # class method: all
    def self.all
      # for each row in CSV file read in and create an instance of trip
      @all_drivers = []
      CSV.foreach("/Users/tamikulon/ada/classwork/week5/ride-share-two/support/trips.csv", {:headers => true}) do |row|
        @all_drivers << RideShare::Trip.new(
        id: row[0],
        driver_id: row[1],
        rider_id: row[2],
        date: row[3],
        rating: row[4]
        )
      end
      return @all_drivers # return all instances of trips
    end

    # class method: by_ridertr(rider_id)
    def self.by_rider(rider_id)
      # find all instances of trips where rider_id matches
      all.select { |trip| trip.rider_id == rider_id }
      # return collection of trips by specific rider
    end

      # class method: by_driver(driver_id)
    def self.by_driver(driver_id)
      # find all instances of trips where driver_id matches
      all.select { |trip| trip.driver_id == driver_id }
      # return collection of trips by specific driver
    end

    # instance method: find_driver
    def find_driver
      RideShare::Driver.find(@driver_id)
      # return instance of Driver
    end

  # instance method: find_rider
    def find_rider
      RideShare::Rider.find(@rider_id)
      # return instance of Rider
    end
  end
end

# CSV.foreach("/Users/tamikulon/ada/classwork/week5/ride-share-two/support/trips.csv", {:headers => true}) do |row| # file directory for rake
#   if @@all_drivers.select { |driver| driver.id == row[0] } != []
#     next
#   else
#     @@all_drivers << RideShare::Trip.new(
#       id: row[0],
#       driver_id: row[1],
#       rider_id: row[2],
#       date: row[3],
#       rating: row[4]
#     )
#   end
# end
# return @@all_drivers # return all instances of trips
