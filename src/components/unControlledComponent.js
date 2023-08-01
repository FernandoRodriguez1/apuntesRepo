import React, { useRef } from "react";

const UncontrolledComponent = () => {
  const inputRef = useRef();

  const handleSubmit = () => {
    const inputValue = inputRef.current.value; // Obtener el valor del campo de entrada usando useRef
    console.log("Valor ingresado:", inputValue);
  };

  return (
    <div>
      <input type="text" ref={inputRef} />
      <button onClick={handleSubmit}>Enviar</button>
    </div>
  );
};

export default UncontrolledComponent;
/*En este ejemplo, el componente es no controlado porque el valor del campo de entrada se obtiene directamente del DOM utilizando la referencia inputRef.
 React no controla el valor del campo de entrada; en cambio, se utiliza la referencia para acceder al valor cuando sea necesario. 
 
 Los Componentes Controlados vinculan explícitamente los valores de los elementos de 
 formulario al estado de React y actualizan el estado cuando el usuario interactúa con el componente.

Los Componentes No Controlados obtienen los valores de los elementos del 
formulario directamente del DOM y no están vinculados al estado de React, lo que significa que React no controla directamente sus valores
ni actualiza el estado en función de las interacciones del usuario.

La elección entre usar un componente controlado o no controlado depende de las necesidades y la complejidad del componente. 
En general, los componentes controlados ofrecen más control sobre el estado y las interacciones, mientras que los componentes no controlados pueden ser más 
convenientes para casos simples o formularios no complejos.
 
 
 */
