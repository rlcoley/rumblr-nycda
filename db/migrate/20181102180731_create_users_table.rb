class CreateUsersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
        t.string :fname
        t.string :lanme
        t.string :email
        t.string :usersname
        t.string :password

    end
  end
end
