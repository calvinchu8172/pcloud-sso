module PairingHelper

  def check_device_available

    device_id = params[:id]
    if !device_registered?(device_id) 
      flash[:alert] = "device not found"
      redirect_to controller: "discoverer", action: "index" 
    elsif handling?(device_id)
      flash[:alert] = "device is pairing"
      redirect_to controller: "discoverer", action: "index" 
    elsif paired?(device_id)
      flash[:alert] = "device is paired already"
      redirect_to controller: "discoverer", action: "index" 
    end
  end

  def check_pairing_session
    session_id = params[:id]
    @session = PairingSession.find(session_id)
    render :json => {:id => session_id, :status => 'invalid'} unless current_user.id == @session.user_id
  end

  def device_registered?(device_id)
    !DeviceSession.where(:device_id => device_id).empty?
  end

  def handling?(device_id)
    !PairingSession.handling().where(:device_id => device_id).empty?
  end

  def paired?(device_id)
    !Pairing.enabled.where(:device_id => device_id).empty?
  end
end
