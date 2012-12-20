class MoviesController < ApplicationController

  

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']  
    if(params[:key]==nil)
	@movies = Movie.all
    else
	if (session[:keys]!=nil)
		session[:keys]=nil
		@names=""
	end
	@sort = params[:key]
	session[:key]=@sort
	#@movies = Movie.all(:order => params[:key])
   	#@name="hilite"
    end
    
    if(params[:keys]==nil)
	@movies = Movie.all
    else
	if (session[:key]!=nil)
		session[:key]=nil
		@name=""
	end
	@sort = params[:keys]
	session[:keys]=@sort
	
    end

    if (params[:ratings] == nil)
	if(session[:rating]!=nil)
		@choice = {}
		session[:rating].collect {|i| @choice[i]="1"}
		@select = @choice
	else
		@select = {"G"=>"1", "PG"=>"1","PG-13"=>"1","R"=>"1"}
		session[:rating] = @select.keys
	end
    else
	@select=params[:ratings]
        session[:rating]=params[:ratings].keys
	@movies = Movie.find(:all, :conditions => { :rating => session[:rating]})	
    end
	
    if(session[:key]!=nil)
	@name="hilite"
	@movies = Movie.find(:all, :conditions => { :rating => session[:rating]}, :order=>session[:key])
    elsif(session[:keys]!=nil)
	@names="hilite"
	@movies = Movie.find(:all, :conditions => { :rating => session[:rating]}, :order=>session[:keys])
    else
	@movies = Movie.find(:all, :conditions => { :rating => session[:rating]})
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
