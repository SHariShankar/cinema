class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :home]

  def home
  end
    
  def index
    if params[:search].present?
      @movies = Movie.where(["title ILIKE ?","%#{params[:search]}%"])
    else
      @genres = ["Romance","Thriller","Crime","Action","Horror"]
    end
  end

  def show
    @reviews = @movie.reeviews
    @reviewed_users = @reviews.collect(&:user_id)
    @reeview = Reeview.new
  end

  def new
    @movie = current_user.movies.build
  end

  def edit
  end

  def create
    @movie = current_user.movies.build(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:image, :title, :trailer, :description, :movie_length, :director, :rating, :cast, :story, :screenplay, :dialogues, :producer, :lyricists, :music, :cinematography, :language, :genre, :country_code)
    end
end
