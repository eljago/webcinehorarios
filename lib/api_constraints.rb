class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end
  
  def matches?(req)
    @default || req.headers['APIV'].include?("application/cinehorarios.ios.v#{@version}")
  end
end