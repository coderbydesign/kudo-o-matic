namespace :maintenance do 
  desc 'Delete expired data exports to save space'
  task cleanup_expired_exports: :environment do
    ExportService.instance.delete_expired_exports
  end
end
