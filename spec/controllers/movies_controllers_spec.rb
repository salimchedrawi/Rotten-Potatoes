require 'spec_helper'

describe MoviesController do

  describe 'find a movie' do
    it 'should show the movie information' do
      movie = mock('Movie')
      Movie.should_receive(:find).with('1').and_return(movie)
      get :show, {:id => '1'}
      response.should render_template('show')
    end
  end

  describe 'list all movies' do

    it 'should find and list all movies' do
      fake_results = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:find_all_by_rating).and_return(fake_results)
      get :index
      response.should render_template('index')
    end

    it 'should find list all movies, sort by title' do
      get :index, {:sort => 'title', :ratings => 'PG'}
      response.should redirect_to(:sort => 'title', :ratings => 'PG')
    end

    it 'should find list all movies, sort by release_date' do
      get :index, {:sort => 'release_date', :ratings => 'PG'}
      response.should redirect_to(:sort => 'release_date', :ratings => 'PG')
    end

    it 'should find list all movies with rating PG' do
      get :index, {:ratings => 'PG'}
      response.should redirect_to(:ratings => 'PG')
    end

  end

  describe 'show form to add a movie' do
    it 'should show the form for user to create new movie information' do
      get :new
      response.should render_template('new')
    end    
  end

  describe 'create a movie' do
    it 'should create a movie successfully' do
      movie = mock('Movie', :title => 'The Help')
      Movie.should_receive(:create!).and_return(movie)
      post :create, :movie => movie
      response.should redirect_to(movies_path)
    end
  end

  describe 'edit a movie' do
    it 'should show the form to edit the movie information' do
      movie = mock('Movie', :title => 'The Help')
      Movie.should_receive(:find).with('1').and_return(movie)
      get :edit, :id => '1'
      response.should render_template('edit')
    end
  end

  describe 'update a movie' do
    it 'should save the updated movie information' do
      movie = mock('Movie', :id => '1', :title => 'The Help')
      Movie.should_receive(:find).with('1').and_return(movie)
      movie.should_receive(:update_attributes!)
      put :update, :id => '1', :movie => movie
      response.should redirect_to movie_path(movie)
    end
  end

  describe 'delete a movie' do
    it 'should delete the movie' do
      movie = mock('Movie', :id => '1', :title => 'The Help')
      Movie.should_receive(:find).with('1').and_return(movie)
      movie.should_receive(:destroy)
      delete :destroy, :id => '1'
      response.should redirect_to(movies_path)
    end
  end

  describe 'find movies with the same director' do

    it 'should show other movies with the same directory' do
      movie = mock('Movie')
      movie.stub(:title).and_return('The Help')
      movie.stub(:director).and_return('Director Name')
      Movie.should_receive(:find).with('1').and_return(movie)
      fake_results = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:find_same_director).with('1').and_return(fake_results)
      get :same_director, {:id => "1"}
      response.should render_template('same_director')
    end
    
    it 'should redirect to home page and show a warning for no director info' do
      movie = mock('Movie')
      movie.stub(:title).and_return('The Help')
      Movie.should_receive(:find).with('1').and_return(movie)
      Movie.stub(:find_same_director).and_raise(Movie::NoDirectorInfo)
      get :same_director, {:id => "1"}
      response.should redirect_to(movies_path)
    end
    
  end
end