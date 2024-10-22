import React, { createContext, useState, useEffect } from 'react';

export const AuthContext = createContext();

const AuthProvider = ({ children }) => {
  const [isLoading, setIsLoading] = useState(true);
  const [userToken, setUserToken] = useState(null);

  const signIn = async (data) => {
    // Lógica de inicio de sesión (API backend)
    // setUserToken(token);
    setIsLoading(false);
  };

  const signOut = async () => {
    // Lógica de cierre de sesión
    // setUserToken(null);
    setIsLoading(false);
  };

  const signUp = async (data) => {
    // Lógica de registro (API backend)
    // setUserToken(token);
    setIsLoading(false);
  };

  useEffect(() => {
    // Verifica si el usuario está autenticado
    const bootstrapAsync = async () => {
      // Verifica si el usuario está autenticado (local storage o backend)
      // setUserToken(token);
      setIsLoading(false);
    };

    bootstrapAsync();
  }, []);

  return (
    <AuthContext.Provider
      value={{
        isLoading,
        userToken,
        signIn,
        signOut,
        signUp,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export default AuthProvider;