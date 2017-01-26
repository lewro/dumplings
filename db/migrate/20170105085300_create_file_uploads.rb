class CreateFileUploads < ActiveRecord::Migration
  def change
    create_table :file_uploads do |t|

      t.string :upload_file_name
      t.string :upload_content_type
      t.integer :upload_file_size
      t.string :file_type
      t.string :model
      t.integer :user_id
      t.integer :model_id

      t.timestamps
    end
  end
end
