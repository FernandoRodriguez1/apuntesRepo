import React, { useState } from "react";
import tbas from "./tbas";

const dskjsdaja = () => {
  const [leggs, setLeggs] = useState(0);
  const handleChage = (e) => {
    setLeggs(e.target.value);
  };
  const validateleggs = () => {
    if (leggs !== 4) {
      <h1>ERROR</h1>;
    } else {
      <h1>BIEN</h1>;
    }
  };
  return (
    <div>
      <h2>Ingrese la cantidad de patas</h2>
      <tbas onChange={handleChage} />
      {validateleggs}
    </div>
  );
};

export default dskjsdaja;
