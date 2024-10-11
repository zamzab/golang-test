{{define "title"}}
private
{{end}}
{{define "canonical"}}
./private
{{end}}
{{define "description"}}
private
{{end}}

{{define "contents"}}
<div id="infotab">
  <div id="VHSwitchBtn">縦横書き切替</div>
</div>
<div id="editArea">
  <div id="editData" contenteditable="true"></div>
</div>
<script src="./assets/js/cloudEditor.js"></script>

<script>
  const getBoard = () => {
    const url = '/getboard'
    const jwt = sessionStorage.getItem( itemName )
    fetch( url, {
      method:'GET',
      headers:{ 'Authorization': 'Bearer ' + jwt }
    })
    .then( res => {
      // "catch" doesn't work. 40x error handling
      if ( !res.ok ) {
        const contents = document.getElementById( 'contents' )
        contents.insertAdjacentText( 'afterbegin', '会員向けページです。サインインしてください!!' )
        document.querySelector( qElement ).style = 'display:none;'
        return false
      } else {
        res.json()
        .then( myJson => {
          firebase.auth().onAuthStateChanged( user => {
            if( user ){
              const contents = document.getElementById( 'infotab' )
              contents.insertAdjacentHTML( 'afterbegin', user.displayName + ' > ' + 'PrivateRoom' )
              const editor = new cloudEditor({
                TargetID: 'editData',
                Contents: myJson
              })
              setInterval( refreshToken, 10 * 60 * 1000 )
              // setInterval( autosave, 3 * 60 * 1000, editor )
            }
          })
        })
        .catch( () => {
          createBoard()
        })
      }
      return true
    })
  }

  const createBoard = () => {
    const url = '/addboard'
    const jwt = sessionStorage.getItem( itemName )
    fetch( url, {
      method: 'POST',
      headers: { 'Authorization': 'Bearer ' + jwt },
      body: '[{"p":"Welcome Writers-Cloud!"}]'
    })
    .then( res => {
      if( res.ok ){
        window.location.href = '/private'
      } else {
        console.log( err.message )
        alert( 'board作成に失敗しました。' )
      }
    })
  }

  const autosave = editor => {
    const delta = editor.save().then( savedata => {
      // console.log( savedata )
      const url = '/addboard'
      const jwt = sessionStorage.getItem( itemName )
      fetch( url, {
        method: 'POST',
        headers: { 'Authorization': 'Bearer ' + jwt },
        body: JSON.stringify( savedata )
      })
      .then( res => {
        if ( res.ok ) {
          return res.json().then( myJson => {
            console.log( JSON.stringify( myJson ) )
          })
        } else {
          console.log( err.message )
          alert( 'boardの保存に失敗しました。' )
        }
      })
    }).catch( error => {
      console.log('Saving failed: ', error)
    })

  }

  const refreshToken = () => {
    firebase.auth().onAuthStateChanged( user => {
      user.getIdToken( true ).then( rtoken => {
        sessionStorage.setItem( itemName, rtoken )
        console.log( 'refresh token!' )
      })
    });
  }

  signinAuth().then( res => {
    if( res.ok ) {
      firebase.auth().onAuthStateChanged( user => {
        const ev = user.emailVerified
        if( ev ){
          getBoard()
        } else {
          const contents = document.getElementById( 'contents' )
          contents.insertAdjacentText( 'afterbegin', 'Emailが認証されていません！　送信したメールを確認してください。' )
          document.querySelector( qElement ).style = 'display:none;'
        }
      })
    } else {
      const contents = document.getElementById( 'contents' )
      contents.insertAdjacentText( 'afterbegin', 'サインインしてください！　会員向けページです。' )
      document.querySelector( qElement ).style = 'display:none;'
    }
  })

  // Virtical Holizone Switch button
  // const customButton = document.getElementById( 'VHSwitchBtn' )
  // customButton.addEventListener( 'click', () => {
  //   const TargetID = 'vertical-mod'
  //   const TrueVertical = document.getElementById( TargetID )
  //   const c = document.getElementsByClassName( 'ql-container' )[0]
  //   const e = document.getElementsByClassName( 'ql-editor' )[0]
  //   if( TrueVertical ){
  //     c.removeAttribute('id')
  //     e.removeEventListener( 'keydown', verticalKeyType)      
  //   } else {
  //     c.id = TargetID
  //     e.addEventListener( 'keydown', verticalKeyType)
  //   }
  // })

  // function verticalKeyType(e){
    // "keycode" and "keypress" will be deprecated. use "key" and target firefox and chrome on win.
    // discard chrome and safari on Mac.
  //   if(e && !e.isComposing) {
  //     if(e.key === 'ArrowUp'){
  //       e.preventDefault()
  //       e.stopPropagation()
  //       console.log('上')
  //       keyname = 'ArrowRight'
  //     }
  //     if(e.key === 'ArrowDown'){
  //       e.preventDefault()
  //       e.stopPropagation()
  //       console.log('下')
  //       keyname = 'ArrowLeft'
  //     }
  //     if(e.key === 'ArrowLeft'){
  //       e.preventDefault()
  //       e.stopPropagation()
  //       console.log('右')
  //       keyname = 'ArrowUp'
  //     }
  //     if(e.key === 'ArrowRight'){
  //       e.preventDefault()
  //       e.stopPropagation()
  //       console.log('左')
  //       keyname = 'ArrowDown'
  //     }
  //     dispatchKey( keyname )
  //   }
  // }

  // function dispatchKey(key){
  //   const KEvent = new KeyboardEvent( "keydown", {key} )
  //   document.dispatchEvent( KEvent )
  // }

</script>
{{end}}