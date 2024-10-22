import React, { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import InputField from '../components/InputField';
import ButtonComponent from '../components/Button';
import recipeService from '../services/recipeService';

const AddRecipeScreen = () => {
  const navigation = useNavigation();
  const [title, setTitle] = useState('');
  const [preparationTime, setPreparationTime] = useState('');
  const [cookingTime, setCookingTime] = useState('');
  const [difficulty, setDifficulty] = useState('');
  const [ingredients, setIngredients] = useState('');
  const [steps, setSteps] = useState('');
  const [imageUrl, setImageUrl] = useState('');

  const handleAddRecipe = async () => {
    // Valida la información antes de enviarla
    // ... 

    try {
      // Envía los datos a la API (backend)
      await recipeService.addRecipe({
        title,
        preparationTime,
        cookingTime,
        difficulty,
        ingredients: ingredients.split('\n'), // Divide por saltos de línea
        steps: steps.split('\n'), // Divide por saltos de línea
        imageUrl, 
      });

      // Navega a la pantalla de inicio
      navigation.navigate('Home');
    } catch (error) {
      console.error('Error adding recipe:', error);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Agregar Receta</Text>
      <InputField
        label="Título:"
        value={title}
        onChangeText={setTitle}
        placeholder="Nombre de la receta"
      />
      <InputField
        label="Tiempo de Preparación:"
        value={preparationTime}
        onChangeText={setPreparationTime}
        placeholder="Ej: 30 minutos"
      />
      <InputField
        label="Tiempo de Cocción:"
        value={cookingTime}
        onChangeText={setCookingTime}
        placeholder="Ej: 45 minutos"
      />
      <InputField
        label="Dificultad:"
        value={difficulty}
        onChangeText={setDifficulty}
        placeholder="Ej: Fácil, Media, Difícil"
      />
      <InputField
        label="Ingredientes:"
        value={ingredients}
        onChangeText={setIngredients}
        placeholder="Ingresa los ingredientes separados por saltos de línea"
        multiline={true}
        numberOfLines={5}
      />
      <InputField
        label="Pasos:"
        value={steps}
        onChangeText={setSteps}
        placeholder="Ingresa los pasos separados por saltos de línea"
        multiline={true}
        numberOfLines={8}
      />
      <InputField
        label="URL de la Imagen:"
        value={imageUrl}
        onChangeText={setImageUrl}
        placeholder="Pega la URL de la imagen"
      />
      <ButtonComponent title="Agregar Receta" onPress={handleAddRecipe} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20,
  },
});

export default AddRecipeScreen;