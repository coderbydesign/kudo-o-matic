class ExportService
  include Singleton

  def start_new_export(user, format)
    Delayed::Job.enqueue Export::CreateExportJob.new(user, format)
  end

  def delete_expired_exports
    Delayed::Job.enqueue Export::MaintainExportsJob.new
  end
end