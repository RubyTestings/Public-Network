class String

  #return an alternate string if blank
  def or_else(alternate)
    blank? ? alternate : self
  end


  def initial
    self[0].chr
  end

end
