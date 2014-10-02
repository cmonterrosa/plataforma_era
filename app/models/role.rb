class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => 'roles_users'

  ##### TODOS LOS USUARIOS CON CIERTO ROLE ######
  def todos_usuarios
    return User.find_by_sql("SELECT users.* from users inner join roles_users ru on users.id=ru.user_id
                             INNER JOIN roles r on ru.role_id=r.id
                             WHERE (users.blocked=0 or users.blocked IS NULL) AND r.name='#{self.name}'")
  end


end