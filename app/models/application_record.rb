class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.group_by_record(items, model)
    item_id    = "#{model}_id".to_sym
    ids_name   = "#{model}_ids".to_sym
    count_name = "#{model}_count".to_sym

    items.each_with_object([]) do |current_item, blocks|
      last_block = blocks.last
      if last_block && current_item.id == last_block[:id]
        last_block[ids_name] << current_item.send(item_id)
        last_block[count_name] += 1
      else
        blocks << current_item.init_block(current_item, count_name, ids_name, item_id)
      end
    end
  end

  def init_block(item, count_name, ids_name, item_id)
    if item.send(item_id)
      item_count = 1
      item_ids   = [item.send(item_id)]
    else
      item_count = 0
      item_ids = []
    end
    {
      :id => item.id,
      :name => item.name,
      count_name => item_count,
      ids_name => item_ids
    }
  end
end
