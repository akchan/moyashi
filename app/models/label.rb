class Label < ActiveRecord::Base
  belongs_to :project, touch: true
  serialize :white_list


  validates(
    :name,
    uniqueness: {scope: :project_id, message: "That name is already present. Input another name."},
    presence: {message: "Label name can't be blank."},
    exclusion: {in: %w[id created_at updated_at spectrum], message: "%{value} is reserved."}
  )
  # validates :order, uniqueness: {scope: :project_id}


  validates :column_name, presence: true
  before_create :add_column
  after_destroy :remove_column


  private
    def add_column
      self.column_name = project.records.add_column
    end


    def remove_column
      project.records.remove_column(self.column_name)
    end
end
