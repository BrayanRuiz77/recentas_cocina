import React, { useState, useEffect } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { AuthContext } from './src/utils/authContext';
import HomeScreen from './src/screens/HomeScreen';
import RecipeDetailScreen from './src/screens/RecipeDetailScreen';
import AddRecipeScreen from './src/screens/AddRecipeScreen';
import LoginScreen from './src/screens/LoginScreen';
import RegisterScreen from './src/screens/RegisterScreen';
import ProfileScreen from './src/screens/ProfileScreen';
import recipeService from './src/services/recipeService';

const Stack = createNativeStackNavigator();

const App = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [userToken, setUserToken] = useState(null);

  const authContext = React.useMemo(
    () => ({
      signIn: async (data) => {
        // Lógica de inicio de sesión (API backend)
        // setUserToken(token);
        setIsLoading(false);
      },
      signOut: async () => {
        // Lógica de cierre de sesión
        // setUserToken(null);
        setIsLoading(false);
      },
      signUp: async (data) => {
        // Lógica de registro (API backend)
        // setUserToken(token);
        setIsLoading(false);
      },
    }),
    []
  );

  useEffect(() => {
    // Verifica si el usuario está autenticado
    const bootstrapAsync = async () => {
      // Verifica si el usuario está autenticado (local storage o backend)
      // setUserToken(token);
      setIsLoading(false);
    };

    bootstrapAsync();
  }, []);

  if (isLoading) {
    return <Loader />;
  }

  return (
    <AuthContext.Provider value={authContext}>
      <NavigationContainer>
        <Stack.Navigator screenOptions={{ headerShown: false }}>
          {userToken ? (
            <>
              <Stack.Screen name="Home" component={HomeScreen} />
              <Stack.Screen name="RecipeDetail" component={RecipeDetailScreen} />
              <Stack.Screen name="AddRecipe" component={AddRecipeScreen} />
              <Stack.Screen name="Profile" component={ProfileScreen} />
            </>
          ) : (
            <>
              <Stack.Screen name="Login" component={LoginScreen} />
              <Stack.Screen name="Register" component={RegisterScreen} />
            </>
          )}
        </Stack.Navigator>
      </NavigationContainer>
    </AuthContext.Provider>
  );
};

export default App;