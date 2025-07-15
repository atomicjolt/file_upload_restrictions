class AddFileSizeToAccountSettings < ActiveRecord::Migration[5.0]
  tag :predeploy

  def change
    change_table :accounts do |t|
      t.bigint :max_file_size, default: nil, null: true
    end
  end
end
