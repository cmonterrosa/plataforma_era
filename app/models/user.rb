require 'resolv'
require 'digest/sha1'

class User < ActiveRecord::Base
  
  
  
  # ---------------------------------------
  # The following code has been generated by role_requirement.
  # You may wish to modify it to suit your need
  has_many :reportes
  has_and_belongs_to_many :roles, :join_table => 'roles_users'
  belongs_to :escuela
  has_many :evaluacions
  
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end
  # ---------------------------------------
  
  
  
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex_centrotrabajo, :message => Authentication.bad_login_message

  validates_format_of       :nombre,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  #validates_length_of       :nombre,     :maximum => 160

  #validates_presence_of     :email
  #validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  

  before_create :make_activation_code
  before_create :assign_role_by_default

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :nombre, :password, :password_confirmation, :blocked, :reset_code
  attr_accessor :email_not_required


  def has_new_messages?
    ( numero_mensaje_bandeja > 0) ? true : false
  end

  def numero_mensaje_bandeja
    Mensaje.count(:id, :conditions => ["recibe_id = ? AND leido_at IS NULL", self.id])
  end


  def before_save
    if @escuela = Escuela.find_by_clave(self.login.upcase)
       self.escuela_id=@escuela.id
    end
  end


  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end
  

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  def recently_activated?
    @activated
  end

  def is_blocked?
    (self.blocked == true)? true : false
  end
  
  def nombre_full
    nombre = (Escuela.find_by_clave(self.login)) ? Escuela.find_by_clave(self.login).nombre : "#{self.nombre}"
    "#{self.login.upcase} | #{nombre}"
  end

  def login_nombre
    "#{login}  ::  #{nombre}"
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL and (blocked IS NULL or blocked=false)', login] # need to get the salt
    mayusculas= u.authenticated?(password.upcase) if u
    minusculas = u.authenticated?(password.downcase) if u
    u && (mayusculas || minusculas) ? u : nil
    #u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end


  #reset methods
def create_reset_code
  @reset = true
  self.attributes = {:reset_code => Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )}
  save(false)
end

def recently_reset?
  @reset
end

def delete_reset_code
  self.attributes = {:reset_code => nil}
  save(false)
end

 def assign_role_by_default
   self.roles << Role.find_by_name("escuela") if Escuela.find_by_clave(self.login)
   self.roles << Role.find_by_name("directivo") if Directivo.find_by_clave(self.login)
      #--- Si es el primer usuario creado lo hacemos administrador ---
#      self.roles << Role.find_by_name("admin") if User.count(:id) <= 1
 end

  def email_valid?(email=self.email)
      domain = email.match(/\@(.+)/)[1]
      Resolv::DNS.open do |dns|
          @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
      end
      @mx.size > 0 ? true : false
  end


  def email_not_required!
    (self.email_not_required) ? true : false
  end


    protected
      def make_activation_code
            self.activation_code = self.class.make_token
      end
  
end
