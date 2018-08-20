module EmailRegex
  def self.valid_regex
    /(?:"?([^"]*)"?\s)?(?:<?(.+@[^>]+)>?)/i
  end

  def self.extract_address(email_string)
    if (match = email_string.match(valid_regex))
      _, address = match.captures
      address
    end
  end
end