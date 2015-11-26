class Movie < ActiveRecord::Base

  has_many :reviews
  mount_uploader :image, ImageUploader

  validates :title,
    presence: true
  validates :director,
    presence: true
  validates :runtime_in_minutes,
    numericality: { only_integer: true }
  validates :description,
    presence: true
  validates :release_date,
    presence: true

  validate :release_date_is_in_the_past


  scope :search, lambda { |title, director, runtime|
    
    if title
      title = "%#{title.to_s}%"     
    else
      title = ""
    end

    if director
      director = "%#{director.to_s}%"  
    else
      director = ""
    end

    sql = "title LIKE ? AND director LIKE ?"
    
    case runtime.to_i
    when 1 then sql += " AND runtime_in_minutes < 90"
    when 2 then sql += " AND runtime_in_minutes BETWEEN 90 AND 120"
    when 3 then sql += " AND runtime_in_minutes > 120"
    end
    
    where(sql, title, director)
  }


  def review_average
    if reviews.size > 0
      reviews.sum(:rating_out_of_ten)/reviews.size 
    else
      0
    end
  end

  protected

  def release_date_is_in_the_past
    if release_date.present?
      errors.add(:release_date, "should be in the past") if release_date > Date.today
    end
  end

end
