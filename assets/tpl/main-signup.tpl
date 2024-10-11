{{define "title"}}
signup
{{end}}
{{define "canonical"}}
./signup
{{end}}
{{define "description"}}
signup
{{end}}

{{define "contents"}}
<div class="fbox">
    <div class="fluid"></div>
    <div class="dp50"><input id="dname" type="text" placeholder="Display Name" value=""></div>
    <div class="fluid"></div>
</div>
<div class="clear mt10"></div>
<div class="fbox">
    <div class="fluid"></div>
    <div class="dp50"><input id="email" type="text" placeholder="Email" value=""></div>
    <div class="fluid"></div>
</div>
<div class="clear mt10"></div>
<div class="fbox">
  <div class="fluid"></div>
  <div class="dp50"><input id="password" type="password" placeholder="Password" value=""></div>
  <div class="fluid"></div>
</div>
<div class="clear mt30"></div>
<div class="fbox">
  <div class="fluid"></div>
  <div class="dp50"><input id="signup" class="btn" type="button" value="新規登録"></div>
  <div class="fluid"></div>
</div>
<script>
  const signup = () => {
    // add user
    const s = document.querySelector( '#signup' )
    s.addEventListener( 'click', () => {
      let d = document.getElementById( 'dname' ).value
      const e = document.getElementById( 'email' ).value
      const p = document.getElementById( 'password' ).value
      firebase.auth().createUserWithEmailAndPassword( e, p )
      .then( res => {
        if( !d ){
          d = 'John Doe'
        }
        res.user.updateProfile({
          displayName: d
        })
        .then( () => {
          sessionStorage.setItem( itemName, res.user.ra )
          const user = firebase.auth().currentUser
          user.sendEmailVerification()
          .then( () => {
            alert( "登録ありがとうございます！\n確認用の認証メールを送信しました。" )
            window.location.href='/'
          })
          .catch( error => {
            alert( "認証メールの送信に失敗しました！\nprofilesから再送信してください。" )
            window.location.href='/profiles'
          })
        }, err => {
          console.log('Display Nameを保存できませんでした。')
        });        
      })
      .catch( err => {
        alert( err.message )
        console.log( err.message )
      })
    })
  }
  signup()
</script>
{{end}}
