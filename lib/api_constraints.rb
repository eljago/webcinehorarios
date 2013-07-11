class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end
  
  def matches?(req)
    if req.headers['APIV']
      @default || req.headers['APIV'].include?("application/cinehorarios.ios.v#{@version}")
    else
      @default
    end
  end
end