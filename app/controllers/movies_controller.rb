class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    id = params["sorted"]
    # logger.info "---" + id + "---\n" unless id == nil

    @all_ratings = Movie.get_ratings
    @user_selected_ratings = params["ratings"]
    puts @user_selected_ratings
    
    if @user_selected_ratings != nil
      @movies = Movie.find(:all, :order => "title", :conditions => ["rating IN (?)", @user_selected_ratings.keys])
      flash[:user_selected_ratings] = @user_selected_ratings
    else
      @user_selected_ratings = flash[:user_selected_ratings]
      if @user_selected_ratings == nil
        @user_selected_ratings = Hash.new
        @all_ratings.each { |rating| @user_selected_ratings[rating] = 1 }
      else
        flash[:user_selected_ratings] = @user_selected_ratings
      end
      
      puts @user_selected_ratings

      if params["highlight"] == "title_header" 
        @highlight_title = 'hilite' 
        @highlight_release_date = '' 
 
#        if @user_selected_ratings == nil
#          @movies = Movie.find(:all, :order => "title")
#        else
          @movies = Movie.find(:all, :order => "title", :conditions => ["rating IN (?)", @user_selected_ratings.keys])
#        end
      elsif params["highlight"] == "release_date_header"
        @highlight_title = ''
        @highlight_release_date = 'hilite' 
#        if @user_selected_ratings == nil
#          @movies = Movie.find(:all, :order => "release_date")
#        else
          @movies = Movie.find(:all, :order => "release_date", :conditions => ["rating IN (?)", @user_selected_ratings.keys])
#        end
      else
#        if @user_selected_ratings == nil
#          @movies = Movie.find(:all)
#        else
          @movies = Movie.find(:all, :conditions => ["rating IN (?)", @user_selected_ratings.keys])
#        end
      end
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
