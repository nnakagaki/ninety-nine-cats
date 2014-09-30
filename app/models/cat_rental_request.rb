class CatRentalRequest < ActiveRecord::Base

  STATUSES = ["PENDING", "APPROVED", "DENIED"]

  validates_presence_of :start_date, :end_date
  validates :status, inclusion: { in: STATUSES }
  validate :overlapping_approved_requests

  # TODO VALIDATE STARTDATE < ENDDATE, STARTDATE > TIME.NOW

  belongs_to :cat

  def approve!
    self.status = 'APPROVED'
    if self.save
      overlapping_pending_requests.each do |req|
        req.deny!
      end
    else
      raise 'HELL'
    end
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

    CatRentalRequest.find_by_sql([sql, start_date: self.start_date, end_date: self.end_date, cat_id: self.cat_id])

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

    CatRentalRequest.find_by_sql([sql, start_date: self.start_date, end_date: self.end_date, cat_id: self.cat_id])
  end

  def overlapping_approved_requests
    return if self.status != "APPROVED"
    overlapping_requests.each do |req|
      if req.status == "APPROVED"
        errors[:date] << "This cat has already been booked"
      end
    end
  end


end
