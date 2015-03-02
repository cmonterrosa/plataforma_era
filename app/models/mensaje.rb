class Mensaje < ActiveRecord::Base
  def destinatario
    user = User.find(self.recibe_id) if self.recibe_id
    escuela = Escuela.find(user.escuela_id) if user.escuela_id
    destinatario = "#{escuela.clave} - #{escuela.nombre}" if escuela
    destinatario ||= user.nombre if user
    return destinatario
  end

  def remitente
    user = User.find(self.envia_id) if self.envia_id
    escuela = Escuela.find(user.escuela_id) if user.escuela_id
    destinatario = "#{escuela.clave} - #{escuela.nombre}" if escuela
    destinatario ||= user.nombre if user
    return destinatario
   end
end
