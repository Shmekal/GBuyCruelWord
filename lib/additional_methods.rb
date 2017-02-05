
class String
  def without_quotes
    fail("object should be string") unless self.class == String
    quotes = ["\"", "'"]
    quotes.each { |i| self.gsub!(i, '') }
    self
  end

  def without_domain
    fail("object should be string") unless self.class == String
    domain = self._get_domain
    self.gsub!(domain, '').strip
  end

  def domain
    fail("object should be string") unless self.class == String
    self._get_domain.gsub('site:', '')
  end

  def _get_domain
    /(\S*(com|net|co|ru))/.match(self)[0]
  end
end