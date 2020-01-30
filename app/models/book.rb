class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :book_comments, dependent: :destroy
	#バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
	#presence trueは空欄の場合を意味する。
	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	# def self.search(title)
 #  		if title
 #  			Book.where(['title LIKE ?', "%#{title}%"])
 #  		else
 #  			"検索結果が見つかりませんでした"
 #  		end
 #  	end

  	def self.search(search,option,choice)
	    if option == 'Book'
	      if choice == '完全一致'
	       Book.where(['title LIKE ?', "#{search}"])
	      elsif choice == '前方一致'
	        Book.where(['title LIKE ?', "#{search}%"])
	      elsif choice == '後方一致'
	        Book.where(['title LIKE ?', "%#{search}"])
	      elsif choice == '部分一致'
	        Book.where(['title LIKE ?', "%#{search}%"])
	      else
	        "検索結果が見つかりませんでした"
	      end
	    end
	 end

end
