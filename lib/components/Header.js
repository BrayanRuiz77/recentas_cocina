import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image } from 'react-native';
import { useNavigation } from '@react-navigation/native';

const Header = ({ title, showUserIcon, onLogout }) => {
  const navigation = useNavigation();

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{title}</Text>
      {showUserIcon && (
        <TouchableOpacity style={styles.userIcon} onPress={onLogout}>
          {/* Reemplaza con tu icono de usuario */}
          <Image
            source={require('../assets/images/user-icon.png')} 
            style={styles.userIconImage}
          />
        </TouchableOpacity>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 15,
    backgroundColor: '#fff',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
  },
  userIcon: {
    padding: 10,
  },
  userIconImage: {
    width: 30,
    height: 30,
  },
});

export default Header;