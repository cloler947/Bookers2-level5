class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :relationships, class_name: 'Relationship', foreign_key: 'user_id'
  has_many :followings, through: :relationships, source: :followed
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followed_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

  attachment :profile_image, destroy: false

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: {maximum: 50}

  # フォローしようとしている other_user が自分自身ではないかを検証
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(followed_id: other_user.id)
    end
  end

  # relationship が存在すれば destroy
  def unfollow(other_user)
    relationship = self.relationships.find_by(followed_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end


def self.search(search,option,choice)
    if option == 'User'
      if choice == '完全一致'
       User.where(['name LIKE ?', "#{search}"])
      elsif choice == '前方一致'
        User.where(['name LIKE ?', "#{search}%"])
      elsif choice == '後方一致'
        User.where(['name LIKE ?', "%#{search}"])
      elsif choice == '部分一致'
        User.where(['name LIKE ?', "%#{search}%"])
      else
         "検索結果が見つかりませんでした"
      end
    end
  end

end
