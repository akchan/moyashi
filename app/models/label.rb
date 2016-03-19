class Label < ActiveRecord::Base
  belongs_to :project, touch: true


  validates(
    :name,
    uniqueness: {scope: :project_id, message: "That name is already present. Input another name."},
    presence: {message: "Label name can't be blank."},
    exclusion: {in: %w[id created_at updated_at spectrum], message: "%{value} is reserved."}
  )


  before_validation :normalize_white_list
  validate :validates_white_list
  validates :column_name, uniqueness: {scope: :project_id}
  validates :project_id, presence: true

  before_create :add_column
  after_destroy :remove_column


  private
    def normalize_white_list
      self.white_list = self.white_list
                          .gsub(/^[\ 　]+|[\ 　]+$|\r/, "")
                          .gsub(/\n\n+/, "\n")
    end


    def validates_white_list
      new_white_list = white_list.split("\n")
      old_white_list = white_list_was ? white_list_was.split("\n") : []

      deleted_entry = old_white_list - new_white_list

      if deleted_entry.any? && project.records.where(column_name.to_sym => deleted_entry).any?
        errors.add(:white_list, "Deleting [#{deleted_entry.join(", ")}] entries from #{name} label prohibited the label from being saved because some sample have some of these label.")
        self.white_list = white_list_was
      end
    end


    def add_column
      self.column_name = project.records.add_column
    end


    def remove_column
      project.records.remove_column(self.column_name)
    end
end