import React from "react";

const TableInput = ({ onChange }) => {
  return <input type="number" onChange={onChange} min="0" />;
};

export default TableInput;
