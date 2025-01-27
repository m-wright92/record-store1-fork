require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('./lib/song')
require('pry')
require('pg')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "record_store"})

get('/test') do
  @something = "this is a variable"
  erb(:whatever)
end

get('/') do
  @albums = Album.all
  erb(:albums)
end

get ('/albums') do
  @albums = Album.all
  erb(:albums)
end

get ('/albums/new') do
  erb(:new_album)
end

post('/albums') do
  name = params[:album_name]
  album = Album.new({ :name => name.capitalize, :id => nil})
  album.save()
  @albums = Album.all()
  erb(:albums)
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  if @album 
    erb(:album)
  else
    erb(:error)
  end
end

get('/albums/:id/edit') do 
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  @albums = Album.all
  erb(:albums)
end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end

get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  if @song
    erb(:song)
  else
    erb(:error)
  end
end

post('/albums/:id/songs') do
   @album = Album.find(params[:id].to_i())
   song = Song.new({:name => params[:song_name], :album_id => @album.id, :id => nil})
   song.save()
   erb(:album)
end

patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/artists') do
  @artists = Artist.all
  erb(:artists)
end

get('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  if @artist 
    erb(:artist)
  else
    erb(:error)
  end
end

post('/artists') do
  name = params[:artist_name]
  artist = Artist.new({ :name => name.capitalize, :id => nil})
  artist.save
  @artists = Artist.all
  erb(:artists)
end

patch('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  @artist.update(params[:name])
  @artist = Artist.all
  erb(:artists)
end

delete('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  @artist.delete()
  @artists = Artist.all
  erb(:artists)
end