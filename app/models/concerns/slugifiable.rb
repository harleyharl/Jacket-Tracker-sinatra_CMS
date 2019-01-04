module Slugifiable

    def slug
      self.username.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end

    def find_by_slug(slug)
      self.all.detect do |user|
        user.slug == slug
      end
    end

end
