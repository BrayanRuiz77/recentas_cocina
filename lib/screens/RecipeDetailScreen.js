import React, { useState, useEffect } from 'react';
import { View, Text, Image, StyleSheet, ScrollView } from 'react-native';
import { useNavigation } from '@react-navigation/native';

const RecipeDetailScreen = ({ route }) => {
  const navigation = useNavigation();
  const { recipe } = route.params;
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Simula la carga de la receta desde la API (deberías obtenerla del backend)
    setIsLoading(false);
  }, []);

  if (isLoading) {
    return <Loader />;
  }

  return (
    <ScrollView style={styles.container}>
      <Image source={{ uri: recipe.imageUrl }} style={styles.recipeImage} />
      <View style={styles.recipeInfo}>
        <Text style={styles.recipeTitle}>{recipe.title}</Text>
        <View style={styles.recipeDetails}>
          <Text style={styles.detailsLabel}>Tiempo de Preparación:</Text>
          <Text style={styles.detailsValue}>{recipe.preparationTime}</Text>
        </View>
        <View style={styles.recipeDetails}>
          <Text style={styles.detailsLabel}>Tiempo de Cocción:</Text>
          <Text style={styles.detailsValue}>{recipe.cookingTime}</Text>
        </View>
        <View style={styles.recipeDetails}>
          <Text style={styles.detailsLabel}>Dificultad:</Text>
          <Text style={styles.detailsValue}>{recipe.difficulty}</Text>
        </View>
        <View style={styles.recipeIngredients}>
          <Text style={styles.sectionTitle}>Ingredientes:</Text>
          {recipe.ingredients.map((ingredient, index) => (
            <Text key={index} style={styles.ingredient}>
              {ingredient}
            </Text>
          ))}
        </View>
        <View style={styles.recipeSteps}>
          <Text style={styles.sectionTitle}>Pasos:</Text>
          {recipe.steps.map((step, index) => (
            <View key={index} style={styles.step}>
              <Text style={styles.stepNumber}>{index + 1}. </Text>
              <Text style={styles.stepText}>{step}</Text>
            </View>
          ))}
        </View>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  recipeImage: {
    width: '100%',
    height: 200,
  },
  recipeInfo: {
    padding: 20,
  },
  recipeTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  recipeDetails: {
    flexDirection: 'row',
    marginBottom: 5,
  },
  detailsLabel: {
    fontWeight: 'bold',
  },
  detailsValue: {
    marginLeft: 10,
  },
  recipeIngredients: {
    marginTop: 20,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  ingredient: {
    marginBottom: 5,
  },
  recipeSteps: {
    marginTop: 20,
  },
  step: {
    flexDirection: 'row',
    marginBottom: 10,
  },
  stepNumber: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  stepText: {
    marginLeft: 10,
  },
});

export default RecipeDetailScreen;