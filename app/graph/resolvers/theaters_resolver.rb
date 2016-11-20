class TheatersResolver
  def call(obj, args, ctx)
    if args[:cinema_id]
      Theater.where(cinema_id: args[:cinema_id], active: true).order(:name)
    else
      Theater.where(active: true).order(:name)
    end
  end
end