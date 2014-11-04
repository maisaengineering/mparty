class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user, class_name: "Spree::User"

 # validations
  validates :content,presence:  true

  def commented_by
    user.full_name if user
  end

end
