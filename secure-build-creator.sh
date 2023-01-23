#!/bin/sh
#Created by Miticous - https://github.com/miticous

# TEXT COLORS
WARNING_COLOR='\033[0;33m'
SUCCESS_COLOR='\033[1;32m'
ERROR_COLOR='\033[0;31m'
NC='\033[0m'

# EXPECTED PARAMETERS
platforms=(android ios)
testingMode=false

function clear_workspace () {
  rm -rf ./workdir
}

function check_set_android_configs () {
  hasError=false

  # Check if successful seted api key
  API_KEY=$(grep -o '"current_key": *"[^"]*' ./workdir/google-services.json | grep -o '[^"]*$')

  # Check if Android keystore file is setted
  ANDROID_KEYSTORE_PATH="./android/app/release.keystore"
  if [ ! -f "$ANDROID_KEYSTORE_PATH" ]; then
    hasError=true
    echo "${ERROR_COLOR} release.keystore was not setted${NC}"
  fi

  # Check if Android keystore file is setted
  GOOGLE_SERVICES_JSON_PATH="./android/app/google-services.json"
  if [ ! -f "$GOOGLE_SERVICES_JSON_PATH" ]; then
    hasError=true
    echo "${ERROR_COLOR} google-services.json was not setted${NC}"
  fi

  if $hasError
  then
    echo "Error: ${ERROR_COLOR}Failed to set${NC} ${WARNING_COLOR}$platform${NC} ${ERROR_COLOR}configs${NC}"
    exit 1
  else
    echo "${SUCCESS_COLOR} ---> Successfully setted${NC} ${WARNING_COLOR}$platform${NC} ${SUCCESS_COLOR}configs${NC}"
  fi
}

function set_android_configs () {
  # Set keystore
  cp ./workdir/release.keystore ./android/app

  # Set google-services configs
  cp ./workdir/google-services.json ./android/app
}

function check_generate_android_files_result () {
  hasError=false

  if [ ! -f "./workdir/google-services.json" ]; then
    echo "Error: ${ERROR_COLOR}google-services.json not created${NC}"
    hasError=true
  fi
  if [ ! -f "./workdir/release.keystore" ]; then
    echo "Error: ${ERROR_COLOR}release.keystore not created${NC}"
    hasError=true
  fi

  if $hasError
  then
    echo "${ERROR_COLOR}FAIL${NC} on android files creation"
    exit 1
  else
    echo "${SUCCESS_COLOR} --> Successfully generated${NC} ${WARNING_COLOR}$platform${NC} ${SUCCESS_COLOR}key files${NC}"
  fi
}


function generate_android_files () {
  mkdir -p ./workdir
  echo $ANDROID_KEYSTORE | base64 --decode > ./workdir/release.keystore
  echo "$GSjson" >> ./workdir/google-services.json
}

function check_set_ios_configs () {
  hasError=false

  # Check if Certificate file is setted
  CERTIFICATE_PATH="./certs.p12"
  if [ ! -f "$CERTIFICATE_PATH" ]; then
    hasError=true
    echo "${ERROR_COLOR} certs.p12 was not setted${NC}"
  fi

  # Check if Google Services Plist is setted
  GOOGLE_SERVICES_PLIST_PATH="./ios/pernambucanasVarejoRN/GoogleService-Info.plist"
  if [ ! -f "$GOOGLE_SERVICES_PLIST_PATH" ]; then
    hasError=true
    echo "${ERROR_COLOR} GoogleService-Info.plist was not setted${NC}"
  fi

  # Check if Profile is setted
  PROFILE_PATH="./provisioning.mobileprovision"
  if [ ! -f "$PROFILE_PATH" ]; then
    hasError=true
    echo "${ERROR_COLOR} provisioning.mobileprovision was not setted${NC}"
  fi

  if $hasError
  then
    echo "Error: ${ERROR_COLOR}Failed to set${NC} ${WARNING_COLOR}$platform${NC} ${ERROR_COLOR}configs${NC}"
    exit 1
  else
    echo "${SUCCESS_COLOR} ---> Successfully setted${NC} ${WARNING_COLOR}$platform${NC} ${SUCCESS_COLOR}configs${NC}"
  fi
}

function set_ios_configs () {
  # Set certificate
  cp ./workdir/certs.p12 ./

  # Set GoogleServices Plist
  cp ./workdir/GoogleService-Info.plist ./ios/pernambucanasVarejoRN/

  # Set Profile
  cp ./workdir/provisioning.mobileprovision ./
}

function check_generate_ios_files_result () {
  hasError=false
  if [ ! -f "./workdir/certs.p12" ]; then
    echo "Error: ${ERROR_COLOR}iOS not created${NC}"
    hasError=true
  fi
  if [ ! -f "./workdir/GoogleService-Info.plist" ]; then
    echo "Error: ${ERROR_COLOR}iOS Google Service plist not created${NC}"
    hasError=true
  fi
  if [ ! -f "./workdir/certs.p12" ]; then
    echo "Error: ${ERROR_COLOR}iOS not created${NC}"
    hasError=true
  fi
  if [ ! -f "./workdir/provisioning.mobileprovision" ]; then
    echo "Error: ${ERROR_COLOR}iOS not created${NC}"
    hasError=true
  fi
  if $hasError
  then
    echo "${ERROR_COLOR}FAIL${NC} on ios files creation"
    exit 1
  else
    echo "${SUCCESS_COLOR} --> Successfully generated${NC} ${WARNING_COLOR}$platform${NC} ${SUCCESS_COLOR}key files${NC}"
  fi
}

function generate_ios_files () {
  mkdir -p ./workdir
  echo "$KEY_PEM" >> ./workdir/key.pem
  echo "$CERT_PEM" >> ./workdir/cert.pem
  echo $MOBILE_PROVISION | base64 --decode > ./workdir/provisioning.mobileprovision
  echo "$GSplist" >> ./workdir/GoogleService-Info.plist
  openssl pkcs12 -export -out ./workdir/certs.p12 -in ./workdir/cert.pem -inkey ./workdir/key.pem -passout pass:$DECRYPT_KEY
}

while [ $# -gt 0 ]; do
  case "$1" in
    -platform)
      platform="$2"
      ;;
    -KEY_PEM)
      KEY_PEM="$2"
      ;;
    -CERT_PEM)
      CERT_PEM="$2"
      ;;
    -MOBILE_PROVISION)
      MOBILE_PROVISION="$2"
      ;;
    -GSplist)
      GSplist="$2"
      ;;
    -DECRYPT_KEY)
      DECRYPT_KEY="$2"
      ;;
    -ANDROID_KEYSTORE)
      ANDROID_KEYSTORE="$2"
      ;;
    -GSjson)
      GSjson="$2"
      ;;
    -ENV)
      ENV="$2"
      ;;
    -help)
      help="$2"
      echo "${SUCCESS_COLOR}Welcome to Secure Build Creator!${NC}"
      echo "usage: ${WARNING_COLOR}sh${NC} or ${WARNING_COLOR}bash${NC} ${WARNING_COLOR}this_script.sh${NC} [${SUCCESS_COLOR}-platform${NC}] platform [...-other_params] 'value' "
      echo "       -platorm: ios or android"
      echo "            ios: Requires that next params most to be: ${SUCCESS_COLOR}-KEY_PEM${NC} (key.pem file content)"
      echo "                                                       ${SUCCESS_COLOR}-CERT_PEM${NC} (cert.pem file content)"
      echo "                                                       ${SUCCESS_COLOR}-MOBILE_PROVISION${NC} (provisioning.mobileprovision file content enconded in base64)"
      echo "                                                       ${SUCCESS_COLOR}-GSplist${NC} (GoogleService-Info.plist content, downloaded from firebase app distribution)"
      echo "                                                       ${SUCCESS_COLOR}-DECRYPT_KEY${NC} (password for encode/decode certificates)"
      echo ""
      echo "            android: Requires that next params most to be: ${SUCCESS_COLOR}-ANDROID_KEYSTORE${NC} (*.keystore file content encoded in base64)"
      echo "                                                           ${SUCCESS_COLOR}-GSjson${NC} (google-services.json file content downloaded from firebase app distribution)"
      echo "            env: homolog or production"
      echo "example (osx): sh ./script_file_name.sh -platform android -DECRYPT_KEY 'abcdefghi' -GSjson 'jklmnopqrstu' "
      echo "Created by Miticous - https://github.com/miticous - with 💚 ${ERROR_COLOR}4${NC} ${SUCCESS_COLOR}GO.K${NC}"
      exit 0
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
  shift
done

function validate_ios_mixed_params () {
  is_valid_mix=true

  if [ ! "${KEY_PEM:-}" ]; then is_valid_mix=false;fi
  if [ ! "${CERT_PEM:-}" ]; then is_valid_mix=false;fi
  if [ ! "${MOBILE_PROVISION:-}" ]; then is_valid_mix=false;fi
  if [ ! "${GSplist:-}" ]; then is_valid_mix=false;fi
  if [ ! "${DECRYPT_KEY:-}" ]; then is_valid_mix=false;fi

  if [ $is_valid_mix = false ]
  then
    echo "${ERROR_COLOR}Error${NC}: Missing ${WARNING_COLOR}$platform${NC} args"
    exit 1
  fi
}

function validate_android_mixed_params () {
  is_valid_mix=true

  if [ ! "${ANDROID_KEYSTORE:-}" ]; then is_valid_mix=false;fi
  if [ ! "${GSjson:-}" ]; then is_valid_mix=false;fi

  if [ $is_valid_mix = false ]
  then
    echo "${ERROR_COLOR}Error${NC}: Missing ${WARNING_COLOR}$platform${NC} args"
    exit 1
  fi
}


function validate_ios_single_args () {
  # VALIDATE KEY PEM FILE
  if [[ $(echo "$KEY_PEM" | grep -c "Bag Attributes") -eq 0 ]];
  then
    echo "${ERROR_COLOR}KEY PEM${NC} is an ${ERROR_COLOR}invalid${NC} file"
    exit 1
  fi

  # VALIDATE CERT PEM FILE
  if [[ $(echo "$CERT_PEM" | grep -c "Bag Attributes") -eq 0 ]];
  then
    echo "${ERROR_COLOR}CERT PEM${NC} is an ${ERROR_COLOR}invalid${NC} file"
    exit 1
  fi

  # VALIDATE Mobile Provision
  if [[ $(echo "$MOBILE_PROVISION" | base64 --decode | grep -c "Entitlements") -eq 0 ]];
  then
    echo "${ERROR_COLOR}MOBILE PROVISION${NC} is an ${ERROR_COLOR}invalid${NC} file"
    exit 1
  fi

  # VALIDATE Google Service Plist
  if [[ $(echo "$GSplist" | grep -c "GOOGLE_APP_ID") -eq 0 ]];
  then
    echo "${ERROR_COLOR}Google Service Plist${NC} is an ${ERROR_COLOR}invalid${NC} file"
    exit 1
  fi
}

function validate_android_single_args () {
  # VALIDATE Android Keystore
  if [[ $(echo "$ANDROID_KEYSTORE" | grep -c "==") -eq 0 ]];
  then
    echo "${ERROR_COLOR}release.keystore${NC} is an ${ERROR_COLOR}invalid${NC} file"
    exit 1
  fi

  # VALIDATE Google Services json
  gservicejson=$(echo "$GSjson" | grep -o '"current_key": *"[^"]*' | grep -o '[^"]*$')
  if [[ `echo -n $gservicejson | wc -m` -lt 14 ]];
  then
    echo "${ERROR_COLOR}google-services.json${NC} is an ${ERROR_COLOR}invalid${NC} file"
    exit 1
  fi
}

# VALIDATE PLATFORM ARG
if [[ "${platforms[@]}" =~ $platform ]];
then
  echo "Starting script using \033[1;32m$platform\033[0m platform"
else
  echo "Error: ${ERROR_COLOR}$platform${NC} isn't acceptable value. Valid arg value (${WARNING_COLOR}ios${NC} or ${WARNING_COLOR}android${NC})"
  exit 1
fi

success_all=false

if [[ $platform = "ios" ]];
then
  validate_ios_mixed_params
  validate_ios_single_args
  generate_ios_files
  check_generate_ios_files_result
  set_ios_configs
  check_set_ios_configs
  success_all=true
fi

if [[ $platform = "android" ]];
then
  validate_android_mixed_params
  validate_android_single_args
  generate_android_files
  check_generate_android_files_result
  set_android_configs
  check_set_android_configs
  success_all=true
fi

if $success_all;
then
  echo "${SUCCESS_COLOR} ----> Build Creator finished with no errors${NC}"
fi

clear_workspace
echo "${WARNING_COLOR} WORKSPACE CLEANED"
