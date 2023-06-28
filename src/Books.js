import React from "react";

const Books = ({ books }) => {
  const booksfiltered = books.filter((book) => book.rating > 8);

  return (
    <div>
      {booksfiltered.map((book) => (
        <Book key={book.title} title={book.title} rating={book.rating} />
      ))}
    </div>
  );
};
const Book = ({ title, rating }) => {
  return (
    <div>
      <h1>{title}</h1>
      {rating > 9 ? <p style={{ color: "red" }}>{rating}</p> : <p>{rating}</p>}
    </div>
  );
};

export default Books;
