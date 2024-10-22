import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, StyleSheet } from 'react-native';
import RecipeCard from '../components/RecipeCard';
import { AuthContext } from '../utils/authContext';
import Header from '../components/Header';
import Loader from '../components/Loader';
import recipeService from '../services/recipeService';

const HomeScreen = () => {
  const [recipes, setRecipes] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const { signOut } = React.useContext(AuthContext);

  useEffect(() => {
    const fetchRecipes = async () => {
      setIsLoading(true);
      try {
        const data = await recipeService.getRecipes();
        setRecipes(data);
      } catch (error) {
        // Manejar errores
        console.error('Error fetching recipes:', error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchRecipes();
  }, []);

  if (isLoading) {
    return <Loader />;
  }

  return (
    <View style={styles.container}>
      <Header title="RecetApp" showUserIcon={true} onLogout={signOut} />
      <FlatList
        data={recipes}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => (
          <RecipeCard recipe={item} navigation={navigation} />
        )}
        style={styles.recipeList}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  recipeList: {
    paddingHorizontal: 20,
    paddingTop: 20,
  },
});

export default HomeScreen;