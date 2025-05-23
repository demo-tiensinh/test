class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :due_date, null: false
      t.string :status, null: false, default: 'to_do'

      t.timestamps
    end

    add_index :tasks, :status
    add_index :tasks, :due_date
  end
end
