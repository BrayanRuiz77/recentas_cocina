import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { AuthContext } from '../utils/authContext';
import Header from '../components/Header';

const ProfileScreen = () => {
  const { signOut } = React.useContext(AuthContext);

  return (
    <View style={styles.container}>
      <Header title="Perfil" showUserIcon={true} onLogout={signOut} />
      <Text style={styles.title}>Tu Perfil</Text>
      {/* Agrega información del usuario aquí (nombre, correo electrónico, etc.) */}
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

export default ProfileScreen;