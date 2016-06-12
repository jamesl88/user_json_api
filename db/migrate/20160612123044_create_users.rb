class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, index: true
      t.string :last_name, index: true
      t.string :email, index: true
      t.string :encrypted_password
      t.string :salt
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
