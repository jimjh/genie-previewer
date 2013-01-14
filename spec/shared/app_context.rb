shared_context 'app' do

  before :all do
    @root = Test::ROOT + 'data' + 'markdown'
    Aladdin.prepare from: @root
  end

  def app; Aladdin::App end

end
