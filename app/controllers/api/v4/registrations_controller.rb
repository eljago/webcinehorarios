class Api::V4::RegistrationsController < Devise::RegistrationsController

  def create
    @member = Member.create(params[:member])
    if @member.save
      render :json => {:state => {:code => 0}, :data => @member }
    else
      render :json => {:state => {:code => 1, :messages => @member.errors.full_messages} }
    end

  end
end