class Prescription < ApplicationRecord
   belongs_to :consultation
    has_many :prescription_items, dependent: :destroy 
    accepts_nested_attributes_for :prescription_items 
  end