class String
  def promptify
    if self[-1].eql?(':')
      self
    else
      "#{self}:"
    end.titleize
  end
end