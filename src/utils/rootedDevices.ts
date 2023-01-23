import JailMonkey from 'jail-monkey';
import {Alert} from 'react-native';
import RNExitApp from 'react-native-exit-app';

const rootedDevices = {
  prevent: (): void => {
    const isRootedDevice = JailMonkey.isJailBroken();

    if (!__DEV__ && isRootedDevice) {
      Alert.alert(
        'Ops!',
        'Seu dispositivo não possui a segurança necessária para utilizar esse aplicativo.',
        [
          {text: 'Cancel', onPress: () => RNExitApp.exitApp()},
          {text: 'OK', onPress: () => RNExitApp.exitApp()},
        ],
      );
    }
  },
};

export default rootedDevices;
