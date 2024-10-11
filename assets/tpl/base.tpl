<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1">
    <meta name="description" content="{{template "description" .}}">
    <link rel="shortcut icon" href="/assets/images/favicon.png">
    <link rel="canonical" href="{{template "canonical" .}}">
    <title>{{template "title" .}}</title>
    <link rel="stylesheet" href="/assets/css/luxbar.min.css">
    <link rel="stylesheet" href="/assets/css/main.min.css">
  </head>
  <body>
    <!-- firebase -->
    <script src="https://www.gstatic.com/firebasejs/5.9.4/firebase-app.js"></script>
    <script src="https://www.gstatic.com/firebasejs/5.9.4/firebase-auth.js"></script>
    <script>
      var config = {
        apiKey: '00000',
        authDomain: 'writers-cloud.firebaseapp.com',
        databaseURL: 'https://writers-cloud.firebaseio.com',
        projectId: 'writers-cloud',
        storageBucket: 'writers-cloud.appspot.com',
        messagingSenderId: '00000'
      };
      firebase.initializeApp(config);
      // global
      const itemName = 'jwt'
      const jwt = sessionStorage.getItem( itemName )
    </script>
    {{template "header" .}}
    <div class="clear"></div>
    <script src="./assets/js/common.js"></script>
    <div id="contents">{{template "contents" .}}</div>
    <div class="clear"></div>
    {{template "footer" .}}
  </body>
</html>
