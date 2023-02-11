const body = document.querySelector('body'),
      sidebar = body.querySelector('nav'),
      toggle = body.querySelector(".toggle"),
      searchBtn = body.querySelector(".search-box"),
      modeSwitch = body.querySelector(".toggle-switch"),
      modeText = body.querySelector(".mode-text");

    
toggle.addEventListener("click" , () => {
    sidebar.classList.toggle("close");
    if (sidebar.classList.contains("close")) {
        localStorage.setItem("status", "close");
    } else {
        localStorage.setItem("status", "open");
    }
});

let getMode = localStorage.getItem("mode");
if (getMode && getMode === "dark") {
    body.classList.toggle("dark");
} 

let getStatus = localStorage.getItem("status");
if (getStatus && getStatus === "open") {
    sidebar.classList.toggle("close");
} 

modeSwitch.addEventListener("click" , () => {
    body.classList.toggle("dark");
    
    if (body.classList.contains("dark")) {
        modeText.innerText = "Светлая тема";
        localStorage.setItem("mode", "dark");
    } else {
        modeText.innerText = "Темная тема";
        localStorage.setItem("mode", "light");
    }
});

// Check to see if Media-Queries are supported
if (window.matchMedia) {
    // Check if the dark-mode Media-Query matches
    if (window.matchMedia('(prefers-color-scheme: light)').matches) {
        body.classList.toggle("dark");
        modeText.innerText = "Светлая тема";
    } else {
        modeText.innerText = "Темная тема";
    }
} else {
    // Default (when Media-Queries are not supported)
}