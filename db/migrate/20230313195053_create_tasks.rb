class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :actions
      t.text :rules

      t.timestamps
    end
  end
end