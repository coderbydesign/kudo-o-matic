# frozen_string_literal: true

Export::MaintainExportsJob = Struct.new do
  def perform
    exports = Export.where('created_at < ?', 1.week.ago)
    exports.each do |e|
      File.delete(e.zip) if File.exist?(e.zip)
    end
    exports.destroy_all
  end
end
