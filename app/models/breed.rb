class Breed < ApplicationRecord
  has_many :taggables, inverse_of: :breed, dependent: :destroy
  has_many :tags, through: :taggables

  validates :name, presence: true
  accepts_nested_attributes_for :taggables, allow_destroy: true

  def delete_hanging_tags
    self.tags.select do |tag|
      breeds = tag.breeds.load
      breeds.count == 1 && breeds.first == self
    end.each(&:destroy)
  end

  # This method is created to avoid round trip(in a loop) to db
  def create_tags(tag_titles)
    existing_tags    = Tag.where(title: tag_titles)
    existing_tag_ids = existing_tags.collect(&:id)
    existing_tag_titles = existing_tags.collect(&:title)
    non_attached_ids = (existing_tag_ids - self.taggables.collect(&:tag_id)).collect{|tag_id| {tag_id: tag_id}}
    new_titles       = (tag_titles - existing_tag_titles).collect{ |title| {title: title} }
    self.tags.create(new_titles)
    self.taggables.create(non_attached_ids)
  end

  def self.tag_statistics
    breeds = Breed.left_outer_joins(:taggables).select("breeds.id, breeds.name, taggables.tag_id").order("breeds.id")
    group_by_record(breeds, :tag)
  end

end
