class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Relationships

  has_many :projects

  # Callbacks

  after_create :load_projects

  # Validations

  validates :name, :budget, presence: true

  # Methods

  def load_projects
    projects = Project.all
    self.projects.push(projects)
  end

end
