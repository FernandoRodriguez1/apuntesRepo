import React, { useState, useMemo } from "react";

const FactorialCalculator = () => {
  const [number, setNumber] = useState(0);

  const calculateFactorial = (n) => {
    console.log(`Calculating factorial of ${n}`);
    if (n <= 1) return 1;
    return n * calculateFactorial(n - 1);
  };

  // Utilizamos useMemo para memorizar el resultado de calculateFactorial
  const factorial = useMemo(() => calculateFactorial(number), [number]);

  return (
    <div>
      <h2>Factorial Calculator</h2>
      <input
        type="number"
        value={number}
        onChange={(e) => setNumber(e.target.value)}
      />
      <p>
        Factorial of {number} is: {factorial}
      </p>
    </div>
  );
};

export default FactorialCalculator;
