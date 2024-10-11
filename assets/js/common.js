const deleteItem = async () => {
  const items = document.querySelectorAll( "li.luxbar-item" )
  items.forEach( item => {
    item.remove()
  })
}

const addItem = async () => {
  const el = document.querySelector( "li.luxbar-header" )
  el.insertAdjacentHTML( 'afterend', '<li class="luxbar-item"><a href="/" id="signout">signout</a></li>' )
  el.insertAdjacentHTML( 'afterend', '<li class="luxbar-item"><a href="/profiles">profiles</a></li>' )
  el.insertAdjacentHTML( 'afterend', '<li class="luxbar-item"><a href="/private">private</a></li>' )
}

const signout = () => {
  sessionStorage.removeItem( itemName )
  firebase.auth().signOut()
  .then( () => {
    window.location.href = '/'
  })
  .catch( err => {
    console.log( err )
    window.location.href = '/'
  })
}

const signinAuth = async () => {
  return fetch('/auth',
  {
  	method: "GET",
    headers: { 'Authorization': 'Bearer ' + jwt }
  })
  .then( res => res )
  .catch( error => console.log( error ) )
}

if( jwt ){
  (async () => {
    const res = await signinAuth()
    if( res.ok ) {
      await deleteItem()
      await addItem()
      const so = document.getElementById( 'signout' )
      so.addEventListener( 'click', () => {
        signout()
      })
    } else {
      sessionStorage.removeItem( itemName )
    }
  })()
}

