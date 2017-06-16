class AddPaperclipToTransaction < ActiveRecord::Migration[5.0]
  def change
    add_attachment :transactions, :image
  end
end
