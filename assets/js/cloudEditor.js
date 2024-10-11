class cloudEditor {
  constructor( option ) {
    this.TargetID = option.TargetID
    this.Contents = option.Contents
    console.log(JSON.stringify(this.Contents))
    console.log(JSON.parse(this.Contents))
    // for (let index = 0; index < this.Contents.length; index++) {
    //   const element = this.Contents.Contents[index];
      
    //   document.getElementById( this.TargetID ).innerHTML =       
    // }
  }
}
