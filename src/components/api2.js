import React, { useState, useEffect } from "react";

function App2() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    // Realizar la solicitud a la API cuando el componente se monte
    fetch("https://jsonplaceholder.typicode.com/users")
      .then((response) => response.json())
      .then((data) => setUsers(data))
      .catch((error) => console.error("Error fetching data:", error));
  }, []);

  return (
    <div className="App">
      <h1>Listado de Usuarios</h1>
      <ul>
        {users.map((user) => (
          <li key={user.id}>
            <strong>{user.name}</strong> - {user.email}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App2;
