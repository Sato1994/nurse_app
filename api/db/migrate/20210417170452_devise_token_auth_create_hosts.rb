class DeviseTokenAuthCreateHosts < ActiveRecord::Migration[6.0]
  def change
    
    create_table(:hosts) do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean  :allow_password_change, :default => false

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      ## Trackable()
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Host Info
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :address
      t.string :image
      t.boolean :wanted, null: false, default: false
      t.text :profile
      

      ## Tokens
      t.text :tokens

      t.timestamps
    end

    add_index :hosts, :email,                unique: true
    add_index :hosts, [:uid, :provider],     unique: true
    add_index :hosts, :reset_password_token, unique: true
    add_index :hosts, :confirmation_token,   unique: true
    # add_index :hosts, :unlock_token,         unique: true
  end
end
