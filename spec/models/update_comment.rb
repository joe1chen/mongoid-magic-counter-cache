class UpdateComment
  include Mongoid::Document
  include Mongoid::MagicCounterCache

  belongs_to :post

  field :remark
  field :is_published, type: Boolean, default: false

  if Mongoid::Compatibility::Version.mongoid7_or_older?
    counter_cache :post, :if => Proc.new { |act| (act.is_published)  }, :if_update => Proc.new { |act| act.changes['is_published'] }
  else
    counter_cache :post, :if => Proc.new { |act| (act.is_published)  }, :if_update => Proc.new { |act| act.previous_changes['is_published'] }
  end
end
