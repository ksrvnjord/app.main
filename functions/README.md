# Cloud Functions

## Important Notes
> We run our Cloud Functions on the `europe-west1` region. This has to be specified server-side and client-side. Otherwise, you will get permission denied errors.

## Writing Cloud Functions
Functions are written in Typescript and are located in the `src` directory.
Your functions should be exported from `src/index.ts`.

To let your Typescript be transpiled to JavaScript on the fly:
```bash
npm run build:watch
```

## Running Cloud Functions locally using the Firebase Emulator
It is recommended to develop using the Firebase Emulator Suite, this greatly improves the development experience.
Waiting for a function to deploy and then test it is a very slow process, the emulator suite allows you to run your functions locally.
To run your functions locally, you must have the Firebase CLI installed.
You can run the Firebase emulator suite by running:
```bash
firebase emulators:start
```

You can slightly modify the Flutter code to use the local emulator instead of the production environment.
```dart
  functions.useFunctionsEmulator("127.0.0.1", 5001); // Add this line to use the local emulator using the address and port of the emulator
```

Read the [docs](https://firebase.google.com/docs/functions/local-emulator) for more information.

### Firestore Emulator
To work with Firestore, you can setup the Firestore emulator aswell.
For more information, see the [docs](https://firebase.google.com/docs/emulator-suite/connect_firestore).


## Testing Cloud Functions
In the `test` directory, you can write tests for your functions.
You can run the tests by running `npm test`.

## Deploying Cloud Functions
You can deploy your functions by running `firebase deploy --only functions`.
Deployment may take a while, so it is recommended to only deploy the functions you are working on with 
`firebase deploy --only functions:alwaysSuccess,functions:makeUppercase`.

> Note: Deployment of **new** functions may take a while, even if the console reports the function is deployed, the function may not be available yet. If you get an error that the function does not exist or authentication fails, wait a few minutes and try again.
