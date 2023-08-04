const ExampleComponent = () => {
  const numbers = [1, 2, 3, 4, 5, 8];

  // La función reducer toma dos parámetros: el acumulador y el elemento actual.
  // En cada iteración, el acumulador se actualiza sumando el elemento actual.
  const sum = numbers.reduce(
    (prevNumbers, currentValue) => prevNumbers + currentValue,
    0
  );

  return (
    <div>
      <p>La suma de los números es: {sum}</p>
    </div>
  );
};

export default ExampleComponent;
