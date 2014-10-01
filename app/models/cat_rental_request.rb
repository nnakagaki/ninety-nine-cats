class CatRentalRequest < ActiveRecord::Base

  STATUSES = ["PENDING", "APPROVED", "DENIED"]

  validates_presence_of :start_date, :end_date
  validates :status, inclusion: { in: STATUSES }
  validate :overlapping_approved_requests
  validate :logical_date_choice

  belongs_to :cat
  belongs_to :requestor,
    class_name: "User",
    foreign_key: :user_id

  def approve!
    self.status = 'APPROVED'
    self.save!
  end

  def deny!
    self.status = 'DENIED'
    self.save!
  end

  private

  def overlapping_pending_requests
    sql = <<-SQL
    SELECT
      *
    FROM
      cat_rental_requests
    WHERE cat_id = :cat_id AND status = 'PENDING' AND NOT
      (start_date > :end_date
        OR
      end_date < :start_date)
    SQL

    CatRentalRequest.find_by_sql([sql,
      start_date: self.start_date,
      end_date: self.end_date,
      cat_id: self.cat_id])
  end

  def overlapping_requests
    sql = <<-SQL
    SELECT
      *
    FROM
      cat_rental_requests
    WHERE cat_id = :cat_id AND NOT
      (start_date > :end_date
        OR
      end_date < :start_date)

    SQL

    CatRentalRequest.find_by_sql([sql,
      start_date: self.start_date,
      end_date: self.end_date,
      cat_id: self.cat_id])
  end

  def overlapping_approved_requests
    return if self.status != "APPROVED"
    if overlapping_requests.any? do |req|
      req.status == "APPROVED"
    end
      errors[:base] << "This cat has already been booked"
    end
  end

  def logical_date_choice
    return unless start_date && end_date
    errors[:base] << 'Start date must precede end date' if start_date > end_date
    errors[:base] << 'Start date must be after today' if start_date < Date.today
  end

end
