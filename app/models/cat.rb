class Cat < ActiveRecord::Base

  COLORS = ["Black", "Calico", "White", "Gray", "Orange"]

  validates_presence_of :birth_date, :color, :name, :sex
  validates :sex, inclusion: { in: ["M", "F"] }
  validates :color, inclusion: { in: COLORS }

  has_many :cat_rental_requests, :dependent => :destroy

  def age
    (Date.now - self.birth_date).year
  end

end
