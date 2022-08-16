module Books
  class ForeignPublication
    include Mongoid::Document
    include Mongoid::MagicCounterCache

    embedded_in :book, :inverse_of => :foreign_publications
    counter_cache :book
  end
end