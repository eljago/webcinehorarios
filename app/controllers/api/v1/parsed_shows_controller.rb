class Api::V1::ParsedShowsController < Api::V1::ApiController

  after_action :update_parsed_show_functions, only: :update

  def index
    per_page = params[:perPage].present? ? params[:perPage] : 15
    parsed_shows_count = ParsedShow.count
    parsed_shows = ParsedShow.order('created_at DESC').paginate(page: params[:page], per_page: per_page).all
    hash_parsed_shows = parsed_shows.as_json
    hash_parsed_shows.each_with_index do |ps, index|
      ps[:show_name] = parsed_shows[index].show_name
    end
    response = {count: parsed_shows_count, parsed_shows: hash_parsed_shows}
    respond_with response
  end

  def orphan
    parsed_shows1 = ParsedShow.where(show_id: nil).select(:id, :name, :show_id, :updated_at)
    parsed_shows2 = ParsedShow.joins(:functions).where('functions.show_id IS ?', nil).distinct
    parsed_shows = parsed_shows1 | parsed_shows2
    parsed_shows.sort_by! { |ps| ps[:updated_at] }

    response = {parsed_shows: parsed_shows}
    respond_with response
  end

  def relevant
    parsed_shows = ParsedShow.joins(:functions)
      .where(functions: {date: Date.current..(Date.current+6), show_id: nil}).distinct

    response = {parsed_shows: parsed_shows}
    respond_with response
  end

  def update
    parsed_show = ParsedShow.find(params[:id])
    parsed_show.update_attributes(parsed_show_params)

    respond_with parsed_show, json: parsed_show
  end

  def destroy
    respond_with ParsedShow.destroy(params[:id])
  end

  private

  def parsed_show_params
    params.require(:parsed_shows).permit(
      :name,
      :show_id
    )
  end

  def update_parsed_show_functions
    if ParsedShow.exists? params[:id]
      parsed_show = ParsedShow.find(params[:id])

      if parsed_show.show_id.present?
        parsed_show.functions.where('functions.show_id IS ?', nil).each do |function|
          function.show_id = parsed_show.show_id
          function.save
        end
      end
    end
  end

end
