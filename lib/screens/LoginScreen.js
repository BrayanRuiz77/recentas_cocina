import React, { useState, useContext } from 'react';
import { View, Text, TextInput, Button, StyleSheet } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import InputField from '../components/InputField';
import ButtonComponent from '../components/Button';
import { AuthContext } from '../utils/authContext';

const LoginScreen = () => {
  const navigation = useNavigation();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const { signIn } = useContext(AuthContext);

  const handleLogin = async () => {
    try {
      await signIn({ username, password });
      navigation.navigate('Home');
    } catch (error) {
      console.error('Error logging in:', error);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Iniciar Sesión</Text>
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
      <ButtonComponent title="Iniciar Sesión" onPress={handleLogin} />
      <View style={styles.registerLink}>
        <Text>¿No tienes una cuenta?</Text>
        <Text style={styles.link} onPress={() => navigation.navigate('Register')}>
          Registrarse
        </Text>
      </View>
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
  registerLink: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 20,
  },
  link: {
    color: '#007bff',
    marginLeft: 5,
  },
});

export default LoginScreen;