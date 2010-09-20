class WillPaginate::Collection

  def first_item; offset + 1; end

  def last_item ; first_item + length - 1; end

  def paginated?; total_entries > size; end
end