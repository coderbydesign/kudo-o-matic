# frozen_string_literal: true

require 'rubygems'
require 'zip'
require 'open-uri'

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
    FileUtils.mkdir_p(tmp_folder) unless File.directory?(tmp_folder)

    # Write temporary data file
    File.open(data_file_path, 'w') do |f|
      f.write(data)
    end

    # Create the zip file and add the data file to it
    tmp_images = []
    zip_file = File.new(
      File.join(tmp_folder, "export_#{user.id}_#{export.uuid}.zip"), 'w'
    )
    tmp_imgs_to_delete = []
    Zip::File.open(zip_file.path, Zip::File::CREATE) do |zip|
      zip.add("user_#{user.id}_data.#{dataformat}", data_file_path)
      transactions.each do |t|
        next unless t.image.exists?
        tmp_file_path = generate_tmp_img_path(export, t.image_file_name)
        tmp_images.push(tmp_file_path)
        IO.copy_stream(open(t.image.url), tmp_file_path)
        zip.add("images/#{t.image_file_name}", tmp_file_path)
        tmp_imgs_to_delete.push tmp_file_path
      end
    end

    # Need to remove the images AFTER closing the zip,
    # or RubyZip will complain that the images don't exist.
    tmp_imgs_to_delete.each do |img|
      File.delete(img) if File.exist?(img)
    end

    # Set file location in Export record
    export.zip = zip_file
    export.save

    # Notify user via email that the export is available for download
    UserMailer.export_done_email(user, export).deliver_now

    # Delete local data and zip file
    File.delete(data_file_path) if File.exist?(data_file_path)
    File.delete(zip_file.path) if File.exist?(zip_file.path)
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

  def tmp_folder
    Rails.root.join('tmp', 'exports')
  end

  def generate_data_file_path(_user, export, format)
    File.join(tmp_folder, "#{export.uuid}_data.#{format}")
  end

  def generate_tmp_img_path(export, filename)
    File.join(tmp_folder, "#{export.uuid}_img_#{filename}")
  end
end
