Source = Struct.new(:name, :url) do
  def initialize(code)
    case code
    when 'SACD'
      name = ''
      url = ''
    when 'BHL'
      name = ''
      url = ''
    else
      name = 'independent statement'
      url = code
    end
    super(name, url)
  end
end
