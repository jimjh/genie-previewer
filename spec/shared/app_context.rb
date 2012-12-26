shared_context 'app' do

  before do
    Aladdin.config = Aladdin::Config.new dir
    require 'aladdin/app'
    Aladdin::App.set :views, Aladdin::VIEWS.merge(markdown: dir)
  end

  def app; Aladdin::App end

end
