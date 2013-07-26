class Movie < ActiveRecord::Base
  def self.get_ratings
    #self.find(:all, :select => "rating")
    #Movie.select("DISTINCT rating")
        
    result = Array.new
    #Movie.select("DISTINCT rating").each do |movie| result << movie.rating end
    Movie.select("DISTINCT rating").each do |movie| result << movie.rating end

    #Movie.select("DISTINCT rating")
    
    result.sort
    #Movie.distinct.pluck("rating")
  end
end
