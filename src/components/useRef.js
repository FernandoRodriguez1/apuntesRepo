import React, { useRef, useState } from "react";

const ClickCounter = () => {
  const [count, setCount] = useState(5);
  const clickCountRef = useRef(0); // Inicializamos el ref con el valor 0

  const handleClick = () => {
    setCount(count + 1);
    clickCountRef.current += 1; // Incrementamos el valor almacenado en el ref
  };

  return (
    <div>
      <p>Contador de clics: {count}</p>
      <p>Contador de clics usando useRef: {clickCountRef.current}</p>
      <button onClick={handleClick}>Hacer clic</button>
    </div>
  );
};

export default ClickCounter;
/*En este ejemplo, hemos creado una referencia clickCountRef utilizando useRef y 
la inicializamos con el valor 0. Cada vez que hacemos clic en el botón, se incrementa tanto el estado count como el valor almacenado
 en el ref clickCountRef.current. Sin embargo, solo el estado count provoca una renderización del componente, mientras que el valor en clickCountRef.current se 
 mantiene sin cambios entre renderizaciones y se actualiza directamente en el DOM sin causar una nueva renderización.
 useRef se utiliza para almacenar valores que no necesariamente afectan la visualización del componente, sino que se usan para almacenar datos o referencias a elementos 
 que se deben acceder y manipular de manera eficiente.
 */
