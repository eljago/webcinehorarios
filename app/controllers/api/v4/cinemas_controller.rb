class Api::V4::CinemasController < Api::V3::ApiController
  
  def show
    @cinema = Cinema.includes(:theaters).where(theaters: {active: true}).find(params[:id])
    @status_code = 1;
  rescue ActiveRecord::RecordNotFound
    @status_code = 0;
    render :json => {:state => {:code => 0}, :data => {} }
  end
  
end