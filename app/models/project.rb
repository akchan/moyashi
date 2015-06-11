class Project < ActiveRecord::Base
  has_many :labels, dependent: :destroy
  accepts_nested_attributes_for :labels

  validates(
    :name,
    uniqueness: {message: "That project name is already present. Input another name."},
    presence: {message: "Project name can't be blank."}
  )
  after_create :create_record_table
  after_destroy :destroy_record_table


  def records
    @records ||= Record.new(self)
  end


  private
  def create_record_table
    records.create_table
  end


  def destroy_record_table
    records.destroy_table
  end
end
