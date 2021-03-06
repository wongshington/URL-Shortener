class ShortenedUrl < ApplicationRecord
  validates :long_url, presence: true, uniqueness: true

  has_many :logged_users,
      primary_key: :id,
      foreign_key: :url_id,
      class_name: :Visit

  has_many :unique_visitors,
    Proc.new {distinct},
    through: :logged_users,
    source: :user

  has_many :visitors,
    through: :logged_users,
    source: :user

    def self.random_code
      code = SecureRandom.urlsafe_base64
      while ShortenedUrl.exists?(code)
        code = SecureRandom.urlsafe_base64
      end
      code
    end

    def self.create_and_generate(user, long_url)
      ShortenedUrl.create!(user_id: user.id,
      long_url: long_url,
      short_url: self.random_code)
    end

    def num_clicks
      visitors.count
    end

    def num_uniques
      unique_visitors.count
    end

    def num_recent_uniques
    end

end
