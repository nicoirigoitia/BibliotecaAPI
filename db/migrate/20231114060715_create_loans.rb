class CreateLoans < ActiveRecord::Migration[5.2]
  def change
    create_table :loans do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.date :loaned_on
      t.date :returned_on
      t.date :due_on

      t.timestamps
    end
  end
end
