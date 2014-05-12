class Api::V3::SessionsController < Devise::SessionsController

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    current_member.update_attribute :authentication_token, nil

    respond_to do |format|
      format.json {
        render :json => {
          member: current_member,
          :status => :ok,
          :authentication_token => current_member.authentication_token
        }
      }
    end
  end

  def destroy
    respond_to do |format|
      format.json {
        if current_member
          current_member.update authentication_token: nil
          signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
          render :json => {}.to_json, :status => :ok
        else
          render :json => {}.to_json, :status => :unprocessable_entity
        end
      }
    end
  end
end