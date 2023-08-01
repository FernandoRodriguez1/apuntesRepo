import React, { useState } from "react";

const ControlledComponent = () => {
  const [inputValue, setInputValue] = useState("");

  const handleChange = (e) => {
    setInputValue(e.target.value); // Actualiza el estado en cada cambio del campo de entrada
  };

  return (
    <div>
      <input type="text" value={inputValue} onChange={handleChange} />
      <p>Valor ingresado: {inputValue}</p>
    </div>
  );
};

export default ControlledComponent;
/*En este ejemplo, el estado inputValue está vinculado al campo de entrada a través del atributo value, y el evento onChange está controlado 
por la función handleChange, que actualiza el estado inputValue en cada cambio del campo de entrada. 
Como resultado, el componente es controlado por el estado de React. */
