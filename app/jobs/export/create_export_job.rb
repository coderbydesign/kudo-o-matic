# frozen_string_literal: true

require 'rubygems'

Export::CreateExportJob = Struct.new(:user, :dataformat) do
  def perform
    ExportGenerator.create_and_send_zip(user, dataformat)
  end

  def queue_name
    'exports'
  end
end
