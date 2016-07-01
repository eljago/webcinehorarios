module ViewsHelper
  def render_backbutton path
    render partial: 'shared/backbutton', locals: { target_path: path }
  end
end
