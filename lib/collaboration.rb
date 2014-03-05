Collaboration = Struct.new(:person, :movie, :role) do
  def initialize(params)
    super(params[:person], params[:movie], params[:role])
  end
end