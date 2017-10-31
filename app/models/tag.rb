class Tag < ApplicationRecord
  has_many :taggables, dependent: :destroy
  has_many :breeds, through: :taggables

  validates :title, presence: true

  def self.breed_statistics
    tags = Tag.left_outer_joins(:taggables).select("tags.id, tags.title as name, taggables.breed_id").order("tags.id")
    group_by_record(tags, :breed)
  end

end
