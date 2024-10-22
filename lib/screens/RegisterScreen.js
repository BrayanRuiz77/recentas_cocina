import React, { useState, useContext } from 'react';
import { View, Text, TextInput, Button, StyleSheet } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import InputField from '../components/InputField';
import ButtonComponent from '../components/Button';
import { AuthContext } from '../utils/authContext';

const RegisterScreen = () => {
  const navigation = useNavigation();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const { signUp } = useContext(AuthContext);

  const handleRegister = async () => {
    try {
      await signUp({ username, password });
      navigation.navigate('Login');
    } catch (error) {
      console.error('Error registering:', error);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Registrarse</Text>
      <InputField
        label="Nombre de Usuario:"
        value={username}
        onChangeText={setUsername}
        placeholder="Ingresa tu nombre de usuario"
      />
      <InputField
        label="Contraseña:"
        value={password}
        onChangeText={setPassword}
        placeholder="Ingresa tu contraseña"
        secureTextEntry={true}
      />
      <ButtonComponent title="Registrarse" onPress={handleRegister} />
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

export default RegisterScreen;