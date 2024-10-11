{{define "header"}}
<header id="luxbar" class="luxbar-fixed">
  <input type="checkbox" class="luxbar-checkbox" id="luxbar-checkbox"/>
  <div class="luxbar-menu luxbar-menu-right luxbar-menu-customcolor">
    <ul class="luxbar-navigation">
      <li class="luxbar-header">
        <a href="/" class="luxbar-brand">logo</a>
        <label class="luxbar-hamburger luxbar-hamburger-doublespin" id="luxbar-hamburger" for="luxbar-checkbox"><span></span></label>
      </li>
      <li class="luxbar-item"><a href="/signin">signin</a></li>
      <li class="luxbar-item"><a href="/signup">signup</a></li>
    </ul>
  </div>
</header>
{{end}}
