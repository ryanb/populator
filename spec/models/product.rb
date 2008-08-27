class Product < ActiveRecord::Base
end

class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string   :name
      t.text     :description
      t.integer  :stock
      t.float    :weight
      t.decimal  :price
      t.datetime :released_at
      t.boolean  :hidden
    end
  end
  
  def self.down
    drop_table :products
  end
end
