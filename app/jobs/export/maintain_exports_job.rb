# frozen_string_literal: true

Export::MaintainExportsJob = Struct.new(:nil) do
  def perform
    Export.all_expired.destroy_all
  end
end
