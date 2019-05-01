module Slugifiable

    def slug #allows slugification of urls, is plugged in to each model
      if self.class == User
        self.username.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      elsif self.class == Jacket
        self.brand.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + "-" + self.jacket_type.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + "-" + self.id.to_s
      elsif self.class == Location
        self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      elsif self.class == Brand
        self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      end
    end

    def find_by_slug(slug) #allows finding by slug, is plugged into each model
      self.all.detect do |item|
        item.slug == slug
      end
    end

end
