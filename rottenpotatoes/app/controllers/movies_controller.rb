class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
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
    @movie = Movie.find(params[:id])
    @movie.director = params[:director] if params[:director].present?
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Movie was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.


  def movie_params
    params.require(:movie).permit(:title, :rating, :release_date, :description, :director)
  end
  def same_director
    # Find the movie by id to get the director's name
    movie = Movie.find(params[:id])
    
    if movie.director.blank?
      redirect_to movies_path, alert: "'#{movie.title}' has no director info"
    else
      # Find other movies by the same director
      @movies = Movie.where(director: movie.director).where.not(id: movie.id)
      puts "@movies is nil" if @movies.nil? # Debugging output
      render :same_director # assuming you have a view template `same_director.html.erb`
    end
  end
end
