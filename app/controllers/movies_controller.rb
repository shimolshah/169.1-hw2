class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings
    
    ratings = Hash.new
    @all_ratings.each { |rating| ratings[rating] = 1 }
    highlight = nil

    if params["ratings"] != nil
      ratings = params["ratings"]
    elsif session[:ratings] != nil
      ratings = session[:ratings]
    end
    session[:ratings] = ratings

    if params["highlight"] != nil
      highlight = params["highlight"]
    elsif session[:highlight] != nil
      highlight = session[:highlight]
    end
    session[:highlight] = highlight

    if highlight != nil
      @movies = Movie.find(:all, :order => highlight, :conditions => ["rating IN (?)", ratings.keys])
    else
      @movies = Movie.find(:all, :conditions => ["rating IN (?)", ratings.keys])
    end
    
    @user_selected_ratings = ratings
    if highlight == "title"
      @highlight_title = "hilite"
      @highlight_release_date = ""
    elsif highlight == "release_date"  
      @highlight_title = ""
      @highlight_release_date = "hilite"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
