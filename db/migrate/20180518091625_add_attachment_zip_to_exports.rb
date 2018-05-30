class AddAttachmentZipToExports < ActiveRecord::Migration
  def self.up
    change_table :exports do |t|
      t.attachment :zip
    end
  end

  def self.down
    remove_attachment :exports, :zip
  end
end
