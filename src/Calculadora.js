import React, { useState } from "react";

const Calculadora = () => {
  const [num1, setnum1] = useState(0);
  const [num2, setnum2] = useState(0);
  const [resultado, setResultado] = useState(0);
  const handlechange1 = (e) => {
    setnum1(e.target.value);
  };
  const handlechange2 = (e) => {
    setnum2(e.target.value);
  };

  const sumavalores = () => {
    const resultado = Number(num1) + Number(num2);
    setResultado(resultado);
  };
  return (
    <div>
      <input type="number" value={num1} onChange={handlechange1}></input>
      <input type="number" value={num2} onChange={handlechange2}></input>
      <button onClick={sumavalores}>Sumar</button>
      {resultado && <p>Resultado: {resultado}</p>}
    </div>
  );
};

export default Calculadora;
