import React, { useEffect, useState } from "react";

const ApiRequest = () => {
  const [answers, setAnswers] = useState([]);
  const [error, setError] = useState(null);

  useEffect(() => {
    const getAnswers = async () => {
      try {
        const response = await fetch(`https://example.com/api`);

        if (response.ok) {
          const data = await response.json();
          setAnswers(data);
        } else {
          setError("Error using fetch method");
        }
      } catch (error) {
        setError(
          "Error al realizar la solicitud de las reseñas: "
        );
      }
    };

    getAnswers();
  }, []);

  return (
    <div>
      {error && <p>Error: {error}</p>}
      <h1>Answers:</h1>
      <pre>{JSON.stringify(answers, null, 2)}</pre>
    </div>
  );
};

export default ApiRequest;
