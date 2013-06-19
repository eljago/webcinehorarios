module IndexActionsHelper
  def render_index_actions obj, options = {}
    options = { only: [:show, :edit, :destroy] }.merge(options)
    render :partial => 'shared/index_actions', :locals => { :arr => [:admin].concat(obj), options: options }
  end
end