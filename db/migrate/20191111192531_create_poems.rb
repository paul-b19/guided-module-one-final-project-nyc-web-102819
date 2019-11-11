class CreatePoems < ActiveRecord::Migration[6.0]
  def change
    create_table :poems do |t|
      t.string :title
      t.integer :length
      t.string :content
      t.integer :author_id

      t.timestamps
    end
  end
end
