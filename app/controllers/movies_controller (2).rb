class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #session.clear
    @all_ratings = Movie.all_ratings
    #@movies = Movie.all
    @checked_ratings = {}

    if ( params[:ratings] == nil ) && ( session[:ratings] == nil )
      session[:ratings] = Movie.all_ratings
      @checked_ratings = session[:ratings]
    #else
    #  @checked_ratings = params[:ratings]
    end

    if ( params[:sort] != nil )
      session[:sort] = params[:sort]
      #@checked_sort = session[:sort]
    end
    
    if session[:sort] != nil
      variable_name = "checked_sort_" + session[:sort]
      instance_variable_set("@#{variable_name}", "hilite")
    end
    
    # title
    #if session[:sort] == "title"
    #  @checked_sort_title 
    #end


    if params[:ratings] != nil
      session[:ratings] = params[:ratings].keys
    end
    
    @checked_ratings = session[:ratings]

    # wtf
    @movies = Movie.find_all_by_rating(@checked_ratings, :order => session[:sort])
      #redirect_to movies_path(:ratings => @checked_ratings, :sort => @checked_sort)
       

    # block - debugging string
    n = "________".to_s
    @deb = n + "params : " + params.to_s + n + "params[:ratings] = " + params[:ratings].to_s + n + "session : " + session.to_s  + n + "session [:ratings] = " + session[:ratings].to_s + n + "flash : " + flash.to_s + n + "checked_ratings" + @checked_ratings.to_s


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