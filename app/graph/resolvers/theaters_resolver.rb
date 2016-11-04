class TheatersResolver
  def call(_, args, _)
    if args[:cinema_id]
      Theater.where(cinema_id: args[:cinema_id], active: true).order(:name)
    else
      Theater.where(active: true).order(:name)
    end
  end
end