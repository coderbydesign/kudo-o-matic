class ExportService
  include Singleton

  def start_new_export(user, team, format)
    Delayed::Job.enqueue Export::CreateExportJob.new(user, team, format)
  end

  def delete_expired_exports
    Delayed::Job.enqueue Export::MaintainExportsJob.new
  end
end