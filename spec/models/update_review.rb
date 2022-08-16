class UpdateReview
  include Mongoid::Document
  include Mongoid::MagicCounterCache

  embedded_in   :article
  if Mongoid::Compatibility::Version.mongoid7_or_older?
    counter_cache :article, :if => Proc.new { |act| (act.is_published)  }, :if_update => Proc.new { |act| act.changes['is_published'] }
  else
    counter_cache :article, :if => Proc.new { |act| (act.is_published)  }, :if_update => Proc.new { |act| act.previous_changes['is_published'] }
  end

  field :comment
  field :is_published, type: Boolean, default: false
end
