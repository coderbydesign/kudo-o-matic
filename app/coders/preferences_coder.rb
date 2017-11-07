# Encodes User preferences to Postgres HStore or JSON data
module PreferencesCoder
  extend self

  def load(data)
    data || {}
  end

  def dump(data)
    data || {}
  end
end
