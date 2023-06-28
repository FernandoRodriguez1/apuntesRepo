import React from "react";

const Movies = ({ movies }) => {
  const filteredMovies = movies.filter((movie) => movie.rating > 8);

  return (
    <div>
      {filteredMovies.map((movie) => (
        <Movie key={movie.title} title={movie.title} rating={movie.rating} />
      ))}
    </div>
  );
};

const Movie = ({ title, rating }) => {
  return (
    <div>
      <h1>{title}</h1>
      <p>{rating}</p>
    </div>
  );
};

export default Movies;
