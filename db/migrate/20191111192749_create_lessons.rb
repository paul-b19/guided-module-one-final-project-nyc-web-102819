class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    def change
      create_table :lessons do |t|
        t.integer :user_id
        t.integer :poem_id
        t.boolean :favorite
  
        t.timestamps
      end
  end
end
