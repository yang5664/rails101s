class Post < ActiveRecord::Base
	scope :recent, -> { order("updated_at DESC") }

	belongs_to :group, counter_cache: :posts_count
	belongs_to :author, class_name: "User", foreign_key: :user_id

	validates :content, presence: true

	def editable_by?(user)
		user && user == author
	end
end
