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
      @movies = Movie.all.order(:title)
      @movie_highlight = "hilite"
    elsif params[:date_sort] == "on"
      @movies = Movie.all.order(:release_date)
      @date_highlight = "hilite"
    else
      @movies = Movie.all
    end
    session[:filtered_ratings] = nil
    if params[:ratings] != nil
      @filtered_ratings = params[:ratings].keys
      session[:filtered_ratings] = @filtered_ratings
      @movies = Movie.all.where({rating: @filtered_ratings})
    end
    @all_ratings = Movie.select(:rating).distinct
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
