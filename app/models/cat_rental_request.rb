class CatRentalRequest < ActiveRecord::Base

  STATUSES = ["PENDING", "APPROVED", "DENIED"]

  validates_presence_of :start_date, :end_date
  validates :status, inclusion: { in: STATUSES }
  validate overlapping_approved_requests

  belongs_to :cat

  private
  def overlapping_requests
    sql = <<-SQL
    SELECT
    first.id, second.id
    FROM
    cat_rental_requests AS first
    JOIN cat_rental_requests AS second
    ON first.cat_id = second.cat_id
    WHERE (first.start_date BETWEEN(second.start_date AND second.end_date) OR
    first.end_date BETWEEN(second.start_date AND second.end_date)) AND
    first.id <> second.id AND first.id < second.id

    SQL

    find_by_sql(sql)
  end

  def overlapping_approved_requests
    overlaps = overlapping_requests

    overlaps.each do |overlap|
      next unless overlap.include?(self.id)
      other_id = overlap.reject { |id| id == self.id }[0]
      if CatRentalRequest.find(id: other_id).status == "APPROVED"
        errors[:date] << "This cat is busy then..."
      end
    end
  end


end
