module SpecHelper

  def correct_age?(min_age,max_age)
    not min_age.nil? and not max_age.nil?
  end

  def correct_gender?(gender)
    gender == "Male" or gender == "Famale"
  end

end
