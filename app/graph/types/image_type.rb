ImageType = GraphQL::ObjectType.define do
  name "Image"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  
  field :image_id, types.Int do
  	resolve -> (image, args, ctx) {
  		image.id
  	}
  end

  field :name, types.String
  field :image_url, types.String
  field :width, types.Int
  field :height, types.Int
end