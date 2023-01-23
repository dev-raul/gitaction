/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React from 'react';
import {StatusBar, StyleSheet, Text, useColorScheme, View} from 'react-native';

import {Colors} from 'react-native/Libraries/NewAppScreen';

const App = () => {
  const theme = useColorScheme();
  const isDarkMode = theme === 'dark';

  const backgroundColor = isDarkMode ? Colors.darker : Colors.lighter;
  const color = isDarkMode ? Colors.lighter : Colors.darker;

  return (
    <>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundColor}
      />
      <View style={[styles.container, {backgroundColor}]}>
        <Text style={[styles.title, {color}]}>GitHub Action</Text>
      </View>
    </>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 20,
  },
});

export default App;
