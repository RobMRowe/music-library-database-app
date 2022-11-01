require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_artists_albums_tables
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection.exec(seed_sql)
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  before(:each) do
    reset_artists_albums_tables
  end

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /artists" do
    it 'returns 200 OK with all artists' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include("<a href='/artists/1'>Pixies</a>")
      expect(response.body).to include("<a href='/artists/2'>ABBA</a>")
    end
  end

  context "POST /artists" do
    it 'returns 200 OK with no content. GET returns 200 OK with all artists, including added record' do
      response = post('/artists',
        name: "Wild Nothing",
        genre: "Indie")

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('Wild Nothing')
    end
  end

  context "GET /albums/1" do
    it 'returns 200 OK with HTML for album with id 1' do
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context "GET /albums/2" do
    it 'returns 200 OK with HTML for album with id 2' do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context "GET /albums" do
    it 'returns 200 OK with HTML listing all albums with /albums/:id links' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include("Title: <a href=\'/albums/1\'>Doolittle</a>")
      expect(response.body).to include('Released: 1989')
      expect(response.body).to include("Title: <a href=\'/albums/12\'>Ring Ring</a>")
      expect(response.body).to include('Released: 1973')
    end
  end

  context "GET /artists/1" do
    it 'returns 200 OK with HTML for artist with id 1' do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')
    end
  end

  context "GET /artists/2" do
    it 'returns 200 OK with HTML for artist with id 2' do
      response = get('/artists/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>ABBA</h1>')
      expect(response.body).to include('Genre: Pop')
    end
  end
end
