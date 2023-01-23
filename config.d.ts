// declare file.
declare module 'react-native-config' {
  export interface NativeConfig {
    ENVIRONMENT: 'HOMOLOG' | 'PRODUCTION';
  }
  export const Config: NativeConfig;
  export default Config;
}
