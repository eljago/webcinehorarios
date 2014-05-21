class Api::V4::CinemasController < Api::V3::ApiController
  
  def show
    @cinema = Cinema.includes(:theaters).where(theaters: {active: true}).find(params[:id])
    @status_code = 1;
  rescue ActiveRecord::RecordNotFound
    render :json => {error: {code:  0, mensaje: "No existe un Cine con id #{params[:id]}.", type: "CHCinemaNotFound"} }
  end
  
end