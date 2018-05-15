# frozen_string_literal: true

Export::MaintainExportsJob = Struct.new do
  def perform
    exports = Export.all_expired
    exports.each do |e|
      File.delete(e.zip) if File.exist?(e.zip)
    end
    exports.destroy_all
  end
end
