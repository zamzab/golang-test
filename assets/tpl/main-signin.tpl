{{define "title"}}
signin
{{end}}
{{define "canonical"}}
./signin
{{end}}
{{define "description"}}
signin
{{end}}

{{define "contents"}}
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
  <div class="dp50"><input id="signin" class="btn" type="button" value="ログイン"></div>
  <div class="fluid"></div>
</div>
<script>
  const signin = () => {
    const sin = document.querySelector( '#signin' )
    sin.addEventListener( 'click', () => {
      const e = document.getElementById( 'email' ).value
      const p = document.getElementById( 'password' ).value
      firebase.auth().signInWithEmailAndPassword( e, p )
      .then( res => {
        sessionStorage.setItem( itemName, res.user.ra )
        window.location.href = '/private'
      })
      .catch(error => {
        alert( error.message )
        console.log( error.message )
      })
    })
  }
  signin()
</script>
{{end}}
