class Taggable < ApplicationRecord
  belongs_to :tag
  belongs_to :breed

  validates :breed, presence: true
  validates :tag, presence: true

  accepts_nested_attributes_for :tag, allow_destroy: true

end
