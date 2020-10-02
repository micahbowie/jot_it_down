class NoteController < ApplicationController
use Rack::MethodOverride
  get '/notes' do
    if !logged_in?
      redirect "/login"
    else
    erb :"notes/all_notes"
   end
  end

  get '/notes/new' do
    if !logged_in?
      redirect "/login"
    else
      erb :"notes/new_note"
    end
  end

  post '/savenote' do
    @note = Note.new
    @note.title = params[:title]
    @note.content = params[:content]
    @note.user_id = User.find_by(:username => session[:username]).id

    if @note.save
      redirect "/notes/#{@note.id}"
    else
      erb :error
    end
  end

  get '/notes/:id/edit' do
    if authenticate_user? == true
      if !logged_in?
        redirect "/login"
      else
        erb :"notes/edit_note"
      end
    else
      erb :error
    end
  end

  get '/notes/:id' do
    if authenticate_user? == true
      if !logged_in?
        redirect "/login"
      else
        erb :"notes/note"
      end
    else
      erb :error
    end
  end

  patch "/notes/:id" do
     @note = Note.find_by(id: params[:id])
     @note.title = params[:title]
     @note.content = params[:content]
     @note.user_id = User.find_by(:username => session[:username]).id
     @note.save
     redirect to "/notes/#{ params[:id] }"
  end

  delete "/notes/:id" do
    if authenticate_user? == true
      note =  Note.find(params[:id])
      note.destroy
      redirect "/notes"
    else
      erb :error
    end
  end
end 
