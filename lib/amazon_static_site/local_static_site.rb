class LocalStaticSite < Sinatra::Base
  get "/" do
    redirect '/index.html'
  end
end