import axios from 'axios';

const BASE_URL = 'http://tu-api-backend.com'; // Reemplaza con tu URL

const recipeService = {
  getRecipes: async () => {
    try {
      const response = await axios.get(`${BASE_URL}/recipes`);
      return response.data;
    } catch (error) {
      throw error;
    }
  },
  addRecipe: async (recipe) => {
    try {
      const response = await axios.post(`${BASE_URL}/recipes`, recipe);
      return response.data;
    } catch (error) {
      throw error;
    }
  },
  // ... (Otros métodos para la API)
};

export default recipeService;