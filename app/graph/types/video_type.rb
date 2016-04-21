VideoType = GraphQL::ObjectType.define do
  name "Video"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  
  field :video_id, types.Int do
  	resolve -> (video, args, ctx) {
  		video.id
  	}
  end
  field :name, types.String
  field :image_url, types.String
  field :code, types.String
end