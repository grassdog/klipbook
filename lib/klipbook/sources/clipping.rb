Klipbook::Clipping = Struct.new(:annotation_id, :text, :location, :type, :page) do
  def self.from_hash(hash)
    self.new.tap do |b|
      b.annotation_id = hash['annotation_id']
      b.text = hash['text']
      b.location = hash['location']
      b.type = hash['type']
      b.page = hash['page']
    end
  end
end
