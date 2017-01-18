class TheatersResolver
  def call(obj, args, ctx)
    if args[:cinema_id]
      Theater.where(cinema_id: args[:cinema_id], active: true).order(:name)
    elsif args[:theater_ids]
      Theater.where(active: true).order(:cinema_id, :name).find(args[:theater_ids].split(','))
    else
      Theater.where(active: true).order(:name)
    end
  end
end