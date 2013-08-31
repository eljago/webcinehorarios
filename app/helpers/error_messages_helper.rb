module ErrorMessagesHelper
  def render_errors(object)
    render :partial => 'shared/error_messages', :locals => { obj: object }
  end
end