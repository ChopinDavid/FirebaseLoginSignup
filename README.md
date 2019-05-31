# FirebaseLoginSignup

FirebaseLoginSignup is a project that aims to help users create a new iOS project that uses Firebase authentication. Simply download the project, add your Firebase info.plist file, add credentials to connect to your Facebook app, and you'll have an application that authenticates users and navigates to a homepage.
<h2>Steps:</h2>
<ol>
   <li>
      <h3>Configure Firebase in your app</h3>
      <ol>
         <li>
            Go to the <a href="https://console.firebase.google.com/u/0/" target="_break">Firebase Console</a> and log in with a Google account.
         </li>
         <li>
            Click "Add Project"
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/addFirebaseProject.png" width=400>
            <br>
            <br>
         </li>
         <li>
            Fill out your project name and accept the terms and conditions.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/firebaseProjectCreation.png" width=400>
            <br>
            <br>
         </li>
         <li>
            Add an iOS app to your project by clicking where indicated.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/addIosApp.png" width=800>
            <br>
            <br>
         </li>
         <li>
            Register the bundle identifier of the app you've downloaded. This should be unique to your project and development team (don't use "com.allcapssoftware.FirebaseLoginSignup").
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/registerBundleID.png" width=800>
            <br>
            <br>
            This is where the bundle identifier can be changed within your project.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/bundleIDLocation.png" width=800>
            <br>
            <br>
         </li>
         <li>
            Download Firebase's configuration file for your app.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/downloadGooglePlist.png" width=800>
            <br>
            <br>
         </li>
         <li>
            Add this configuration file to your project below the "info.plist" file in the "support files" folder.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/googlePlist.png" width=400>
            <br>
            <br>
         </li>
         <li>
            Add <code>FirebaseApp.configure()</code> in your AppDelegate.swift file in the <code>application didFinishLaunchingWithOptions</code> method.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/firebaseConfigure.png" width=800>
            <br>
            <br>
         </li>
         <li>
            Run your app so that Firebase can verify that you've installed correctly. Then click "Continue to console".
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/successfulFirebaseUpload.png" width=400>
            <br>
            <br>
         </li>
      </ol>
   <li>
      <h3>Configure Firebase Authentication</h3>
      <ol>
         <li>
            Click on "Authentication" in the panel on the left side of the Firebase console.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/firebasePanel.png" width=400>
            <br>
            <br>
         </li>
         <li>
            Click on "Set up sign-in method".
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/setupSignin.png" width=800>
            <br>
            <br>
         </li>
         <li>
            Click on the pencil next to the "Email/Password" provider.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/pencil.png" width=800>
            <br>
            <br>
         </li>
         <li>
            Turn the first switch on and save.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/enableEmail.png" width=800>
            <br>
            <br>
         </li>
      </ol>
   </li>
   <li>
      <h3>Configure Firebase database</h3>
      <ol>
         <li>
            Click on "Database" in the panel on the left side of the Firebase console.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/firebasePanel.png" width=400>
            <br>
            <br>
         </li>
         <li>
            Scroll down until you see the "Or choose Realtime Database" option. Click "Create Database".
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/realtimeDatabase.png" width=800>
            <br>
            <br>
         </li>
         <li>
            Click "Enable".
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/enableDatabase.png" width=400>
            <br>
            <br>
         </li>
      </ol>
   </li>
   <li>
      <h3>Configure Firebase Storage</h3>
      <ol>
         <li>
            Click on "Storage" in the panel on the left side of the Firebase console.
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/firebasePanel.png" width=400>
            <br>
            <br>
         </li>
         <li>
            Click on "Get Started" then "Got it".
            <br>
            <br>
            <img src="http://allcapssoftwareinc.com/img/random/getStarted.png" width=800>
            <br>
            <br>
         </li>
         <b><i>You can now log into your app via Email/Password</b></i>
      </ol>
   </li>
   <li>
   <h3>Configure Facebook Login with your app</h3>
   <ol>
      <li>
         Visit the <a href="https://developers.facebook.com/" target="_break">Facebook Developer page</a> and sign into a Facebook developer account. Click on "My Apps" and click "Add New App".
         <br>
         <br>
         <img src="http://allcapssoftwareinc.com/img/random/addNewApp.png" width=800>
         <br>
         <br>
      </li>
      <li>
         Select a name and contact email for your app. Click "Create App ID".
         <br>
         <br>
         <img src="http://allcapssoftwareinc.com/img/random/fbSetup.png" width=800>
         <br>
         <br>
      </li>
      <li>
         In the same place you setup your email authentication in Firebase, click the pencil next to the "Facebook" provider.
         <br>
         <br>
         <img src="http://allcapssoftwareinc.com/img/random/facebookProvider.png" width=800>
         <br>
         <br>
      </li>
      <li>
         Turn on the "Enable" switch and input your app ID and app secret. Then, click "Save".
         <br>
         <br>
         <img src="http://allcapssoftwareinc.com/img/random/appIdAndSecret.png" width=400>
         <br>
         <br>
         The app ID and app secret can be found at the top of the Facebook app page and the settings section of the Facebook app page, respectively.
      </li>
      <li>
         Add your Firebase app's OAuth redirect URI to your Facebook app configuration.
         <br>
         <br>
         <img src="http://allcapssoftwareinc.com/img/random/oauthInFirebase.png" width=400>
         <br>
         <br>
         Go to the Facebook app page and click on "PRODUCTS +" on the left side of the screen.
         <br>
         <br>
         <img src="http://allcapssoftwareinc.com/img/random/productsPlus.png" width=400>
         <br>
         <br>
         Click "Set up" on the "Facebook Login" product option.
         <br>
         <br>
         <img src="http://allcapssoftwareinc.com/img/random/facebookLogin.png" width=400>
         <br>
         <br>
         Under the settings section, look for "Valid OAuth Redirect URIs". Paste the Firebase OAuth URI here.
         <br>
         <br>
         <img src="http://allcapssoftwareinc.com/img/random/validOauthUris.png" width=800>
         <br>
         <br>
      </li>
      <li>
      In the Firebase Console, save the changes made to enable Facebook login in your app.
      </li>
      <li>
         The last step to connecting Facebook Login with your app is to add the <code>FacebookAppID</code> and correct URL Scheme.
         <br>
         <br>
         <img src="http://allcapssoftwareinc.com/img/random/facebookAppID.png" width=800>
         This code is the Facebook App ID found at the top of your app's Facebook Developer page.
         <br>
         <br>
         <img src="http://allcapssoftwareinc.com/img/random/urlScheme.png" width=400>
         Under URL Types→URL Schemes, add "fb" followed by your Facebook App ID.
         <br>
         <br>
         <i><b>Users can now use Facebook to authenticate with your app.</b></i>
      </li>
   </ol>
</li>
</ol>
