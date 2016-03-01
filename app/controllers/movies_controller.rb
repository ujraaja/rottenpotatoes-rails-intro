class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:title_sort] == "on"
      session[:movie_highlight] = "hilite"
      session[:date_highlight] = ""
    elsif params[:date_sort] == "on"
      session[:movie_highlight] = ""
      session[:date_highlight] = "hilite"
    end
    if session[:movie_highlight] == "hilite"
      @movies = Movie.all.order(:title)
    elsif session[:date_highlight] == "hilite"
      @movies = Movie.all.order(:release_date)
    else
      @movies = Movie.all
    end
    if params[:ratings] != nil
      session[:filtered_ratings] = params[:ratings]
    end
    @all_ratings = Movie.select(:rating).distinct
    if session[:filtered_ratings] == nil
      session[:filtered_ratings] = Hash.new
      @all_ratings.each do |ratin|
        session[:filtered_ratings][ratin.rating] = 1
      end
    end
    @movies = @movies.where({rating: session[:filtered_ratings].keys})
    if params != nil
      ln = params.length
      if params[:title_sort].nil? and params[:date_sort].nil? and session[:movie_highlight] == "hilite"
        params[:title_sort] = "on"
      elsif params[:title_sort].nil? and params[:date_sort].nil? and session[:date_highlight] == "hilite"
        params[:date_sort] = "on"
      end
      if params[:ratings].nil? and session[:filtered_ratings]
        params[:ratings] = session[:filtered_ratings]
      end
      if params.length != ln
          redirect_to movies_path(params)
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
