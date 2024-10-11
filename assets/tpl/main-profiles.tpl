{{define "title"}}
profiles
{{end}}
{{define "canonical"}}
./profiles
{{end}}
{{define "description"}}
profiles
{{end}}

{{define "contents"}}
<script>
  const reAuth = async () => {
    const reauthBtn = await viewReAuthForm()
    reauthBtn.addEventListener( 'click', () => {
      const user = firebase.auth().currentUser
      const pass = document.getElementById( 'password' ).value
      const name = user.displayName
      const email = user.email
      const credential = firebase.auth.EmailAuthProvider.credential( email, pass )
      user.reauthenticateAndRetrieveDataWithCredential( credential )
        .then( async () => {
          const el = document.getElementById( 'contents' )
          el.textContent = ''
          const modBtn = await viewProfiles( user, el, email, name )
          modBtn.forEach( target => {
            target.addEventListener( 'click' , () => {
              user.reauthenticateAndRetrieveDataWithCredential( credential )
              .then( () => {
                switch( target ){
                  case document.getElementById( 'passmodify' ):
                    Password.Modify( user )
                    break

                  case document.getElementById( 'mailverified' ):
                    Email.Verified( user )
                    break

                  default:
                    modifyCheck( user )
                    break
                }
              })
            })
          })
        })
        .catch( err => {
          alert( err.message )
        })
    })
  }

  const modifyCheck = user => {
    const modTarget = [ DisplayName, Email ]
    modTarget.forEach( ele => {
      ele.Modify( user )
    })
  }

  const DisplayName = {
    Modify: user => {
      const newName = document.getElementById( 'displayname' ).value
      const name = user.displayName
      if( newName === name ) return false
      user.updateProfile({
        displayName: newName
      })
        .then( () => {
          alert('DisplayNameを更新しました！')
          signout()
          window.location.href = '/signin'
          return true
        })
        .catch( err => {
          alert('DisplayNameが更新できませんでした！')
          console.log( err.message )
          window.location.href = '/profiles'
          return false
        })
    }
  }

  const Email = {
    Verified: user => {
      user.sendEmailVerification()
        .then( () => {
          alert( "確認用の認証メールを送信しました。" )
          window.location.href='/profiles'
          return true
        })
        .catch( error => {
          alert( "アドレス変更しましたが、認証メールの送信に失敗しました！\n再送信してください。" )
          return false
        })
    },
    Modify: user => {
      const newEmail = document.getElementById( 'email' ).value
      const oldEmail = user.email
      if( newEmail === oldEmail ) return false
      // TODO gmail以外の変更元メールアドレスに変更通知が送信されない。
        user.updateEmail( newEmail )
          .then( () => {
            user.sendEmailVerification()
              .then( () => {
                alert( "メールアドレスが変更されました！\n確認用の認証メールを送信しました。" )
                signout()
                window.location.href = '/signin'
              })
              .catch( err => {
                alert( "アドレス変更しましたが、認証メールの送信に失敗しました！\nprofilesから再送信してください。" )
                signout()
                window.location.href = '/signin'
              })
              return true
          })
          .catch( err => {
            alert('Emailアドレスが更新できませんでした！')
            console.log( err )
            return false
          })
    }
  }

  const Password = {
    Modify: user => {
      const Email = user.email
      firebase.auth().sendPasswordResetEmail( Email )
        .then( () => {
          alert( 'パスワードリセットのため、メールを送信しました' )
          signout()
          window.location.href = '/signin'
        })
        .catch( err => {
          console.log( err )
         alert( 'パスワードリセットメールの送信に失敗しました。' )
        })
    }
  }

  const viewReAuthForm = async () => {
    const el = document.querySelector( '#contents' )
    el.insertAdjacentHTML( 'afterbegin', `
    <div class="fbox">
      <div class="fluid"></div>
      <div class="dp50">
        <input id="password" type="password" placeholder="Password" value="">
      </div>
      <div class="fluid"></div>
    </div>
    <div class="clear mt30"></div>
    <div class="fbox">
      <div class="fluid"></div>
        <div class="dp50">
          <input id="reauth" class="btn" type="button" value="再認証">
        </div>
        <div class="fluid"></div>
    </div>
    `)
    const target = document.getElementById( 'reauth' )
    return target
  }

  const viewProfiles = async ( user, element, email, name) => {
    element.insertAdjacentHTML( 'afterbegin', `
    <div class="clear mt30"></div>
      <div class="fbox">
        <div class="fluid"></div>
        <div class="dp50"><h3>Password</h3></div>
        <div class="fluid"></div>
      </div>
      <div class="clear mt20"></div>
      <div class="fbox">
        <div class="fluid"></div>
          <div class="dp50">
            <input id="passmodify" type="button" class="btn"  value="パスワードの変更メール送信">
          </div>
          <div class="fluid"></div>
      </div>
      ` )
    if( user.emailVerified ){
      element.insertAdjacentHTML( 'afterbegin', `
        <div class="clear mt10"></div>
        <div class="fbox">
          <div class="fluid"></div>
          <div class="dp50">
            <input id="emailmodify" type="button" class="btn"  value="変更を保存">
            <input type="button" class="disabled-btn mt10" value="メール認証済み" disabled>
          </div>
          <div class="fluid"></div>
        </div>
        ` )
    } else {
      element.insertAdjacentHTML( 'afterbegin', `
        <div class="clear mt10"></div>
        <div class="fbox">
          <div class="fluid"></div>
          <div class="dp50">
            <p class="alert">※認証メールを送信して本人確認をしましょう。</p>
            <input id="emailmodify" type="button" class="btn"  value="変更を保存">
            <input id="mailverified" type="button" class="btn mt10"  value="認証メールを送信">
          </div>
          <div class="fluid"></div>
        </div>
        ` )
    }
    element.insertAdjacentHTML( 'afterbegin', `
    <div class="fbox">
        <div class="fluid"></div>
        <div class="dp50"><h3>Display Name</h3></div>
        <div class="fluid"></div>
      </div>
      <div class="fbox">
        <div class="fluid"></div>
        <div class="dp50"><input id="displayname" type="displayname" placeholder="Displayname" value="` + name + `"></div>
        <div class="fluid"></div>
      </div>
      <div class="clear mt20"></div>
        <div class="fbox">
          <div class="fluid"></div>
            <div class="dp50">
              <input id="DNmodify" type="button" class="btn"  value="変更を保存">
            </div>
            <div class="fluid"></div>
        </div>
      <div class="clear mt30"></div>
      <div class="fbox">
        <div class="fluid"></div>
        <div class="dp50"><h3>Email</h3></div>
        <div class="fluid"></div>
      </div>
      <div class="fbox">
        <div class="fluid"></div>
        <div class="dp50"><input id="email" type="email" placeholder="Email" value="` + email + `"></div>
        <div class="fluid"></div>
      </div>
      ` )
      let target = []
      if( user.emailVerified ){
        target = [
          document.getElementById( 'passmodify' ),
          document.getElementById( 'emailmodify' ),
          document.getElementById( 'DNmodify' )
        ]
      } else {
        target = [
          document.getElementById( 'passmodify' ),
          document.getElementById( 'mailverified' ),
          document.getElementById( 'emailmodify' ),
          document.getElementById( 'DNmodify' )
        ]
      }
      return target
  }

  (async () => {
    const res = await signinAuth()
    if( res.ok ) {
      reAuth()
    } else {
      const contents = document.getElementById( 'contents' )
      contents.insertAdjacentText( 'afterbegin', '会員向けページです。サインインしてください!!' )
    }
  })()

</script>
{{end}}