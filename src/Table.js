import React, { useState } from "react";
import TableInput from "./kaka";

const Table = () => {
  const [leggs, setLeggs] = useState(0);

  const handleClick = (e) => {
    setLeggs(e.target.value);
  };
  return (
    <div>
      <h1>Ingrese el numero</h1>
      <TableInput kaka={handleClick} />
      {leggs === "4" ? <p>CORRECTO</p> : <p>ERROR</p>}
    </div>
  );
};

export default Table;
