import React, { useState } from "react";

const FormRunner = () => {
  const [days, setDays] = useState(1);

  const handleIncrement = () => {
    if (days < 8) {
      setDays(days + 1);
    }
  };

  const handleDecrement = () => {
    if (days > 0) {
      setDays(days - 1);
    }
  };

  return (
    <div>
      <input
        type="number"
        value={days}
        onChange={(e) => setDays(parseInt(e.target.value))}
      />

      <Button onClick={handleIncrement}>+</Button>
      <Button onClick={handleDecrement}>-</Button>

      {days > 7 && <p>¡La semana solo tiene 7 días!</p>}
      {days <= 0 && <p>¡La semana tiene 1-7 días!</p>}
    </div>
  );
};

const Button = ({ children, onClick }) => {
  return <button onClick={onClick}>{children}</button>;
};
export default FormRunner;
