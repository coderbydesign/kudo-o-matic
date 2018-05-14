# frozen_string_literal: true

require 'rubygems'
require 'zip'

Export::CreateExportJob = Struct.new(:user, :dataformat) do
  def perform
    transactions = Transaction.all_for_user(user)
    likes = Vote.all_for_user(user)
    export = Export.create(uuid: SecureRandom.uuid, user: user)

    # Notify user via email that the export has started
    UserMailer.export_start_email(user).deliver_now

    # Render data in given format (JSON or XML)
    data = render_data(user, transactions, likes, dataformat)
    data_file_path = generate_data_file_path(user, export, dataformat)

    # Create tmp folder if it doesn't exist
    dir = File.dirname(data_file_path)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    # Write temporary data file
    File.open(data_file_path, 'w') do |f|
      f.write(data)
    end

    # Create the zip file and add the data file to it
    zip_file = File.new(
      Rails.root.join('exports', 'users', user.id.to_s,
                      "export_#{export.uuid}.zip"), 'w'
    )
    Zip::File.open(zip_file.path, Zip::File::CREATE) do |zip|
      zip.add("user_#{user.id}_data.#{dataformat}", data_file_path)
    end

    # Set file location in Export record
    export.zip = zip_file.path
    export.save

    # Notify user via email that the export is available for download
    UserMailer.export_done_email(user, export).deliver_now

    # Delete temporary data file
    File.delete(data_file_path) if File.exist?(data_file_path)
  end

  def queue_name
    'exports'
  end

  private

  def render_data(user, transactions, likes, format)
    Rabl.render(user, 'users/export',
                view_path: 'app/views',
                locals: {
                  transactions: transactions,
                  votes: likes
                },
                format: format)
  end

  def generate_data_file_path(user, export, format)
    Rails.root.join('tmp', "#{export.uuid}_data.#{format}")
  end
end
