import React, { useState } from "react";
import TableInput2 from "./TableInput2";
const TableForm2 = () => {
  const [leggs, setLeggs] = useState(0);

  const handleChange = (e) => {
    setLeggs(e.target.value);
  };
  return (
    <div>
      <h2>Ingrese la cantidad de patas que tendra la mesa.</h2>
      <TableInput2 leggsnumber={handleChange} />
      <p>{leggs === "4" ? "error" : "CORRECTO"}</p>
    </div>
  );
};

export default TableForm2;
