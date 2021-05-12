class BaseService
  def initialize(args = {})
    args.each do |k, v|
      send "#{k}=", v
    end
  end

  def self.call(args)
    new(args).call
  end
end
