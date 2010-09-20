

class Spec < ActiveRecord::Base

  belongs_to :user

  define_index do
    indexes [:last_name, :first_name], :as => :name, :sortable => true
    indexes :occupation
    indexes [:state, :city], :as => :location, :sortable => true

  end

  ALL_FIELDS = %w(first_name last_name occupation gender birthdate city state zip_code)
  STRING_FIELDS = %w(first_name last_name occupation city state)
  VALID_GENDERS = ["Male", "Female"]
  START_YEAR = 1900
  VALID_DATES = DateTime.new(START_YEAR)..DateTime.now
  ZIP_CODE_LENGTH = 5

  validates_length_of STRING_FIELDS,
                      :maximum => DB_STRING_MAX_LENGTH
  validates_inclusion_of :gender,
                         :in => VALID_GENDERS,
                         :allow_nil => true,
                         :message => "must be male or female"
  validates_inclusion_of :birthdate,
                         :in => VALID_DATES,
                         :allow_nil => true,
                         :message => "is invalid"
  validates_format_of :zip_code,
                      :with => /(^$|^[0-9]{#{ZIP_CODE_LENGTH}}$)/,
                      :message => "must be a five digit number"

 #return users full name
 def full_name
   [first_name, last_name].join(" ")
 end

 #return users location as a single string
 def location(symbol = nil)
   symbol ||= " "
   [city, state, zip_code].join(symbol)
 end

 #return the age using birthdate
 def age
   return if birthdate.nil?

   today = Date.today
   if today.month >= birthdate.month and today.day >= birthdate.day
     today.year - birthdate.year
   else
     today.year - birthdate.year
   end
 end

 private

 def self.sql_distance_away(point)
   haversine = "POWER(SIN((RADIANS(latitude - #{point.latitude}))/2),2) + " +
     "COS(RADIANS(#{point.latitude})) * COS(RADIANS(latitude)) * " +
     "POWER(SIN((RADIANS(longitude - #{point.longitude}))/2),2)"
   radius = 3965*1.6 # now this is in kilometers
   "2 * #{radius} * ASIN(SQRT(#{haversine}))"

 end

end
