class VideosResolver
  def call(obj, args, ctx)
    Video.joins(:show)
      .where('shows.active = ? AND videos.outstanding = ?', true, true)
      .order('videos.created_at DESC')
      .paginate(page: args[:page], per_page: 15).uniq
  end
end