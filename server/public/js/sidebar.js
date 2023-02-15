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

document.addEventListener("DOMContentLoaded", () => {
    // Check to see if Media-Queries are supported
    if (window.matchMedia && !getStatus) {
        // Check if the dark-mode Media-Query matches
        if (window.matchMedia('(prefers-color-scheme: light)').matches) {
            body.classList.toggle("dark");
            // var home = document.getElementById("home");
            body.setAttribute("data-bs-theme", "light");
            modeText.innerText = "Светлая тема";
        } else {
            modeText.innerText = "Темная тема";
            // var home = document.getElementById("home");
            body.setAttribute("data-bs-theme", "dark");
        }
    } else {
        // Default (when Media-Queries are not supported)
    }

    let getMode = localStorage.getItem("mode");
    if (getMode && getMode === "dark") {
        // var home = document.getElementById("home");
        body.setAttribute("data-bs-theme", "light");
    } 
    else {
        // var home = document.getElementById("home");
        body.setAttribute("data-bs-theme", "dark");
    }

    modeSwitch.addEventListener("click" , () => {
        body.classList.toggle("dark");
        
        if (body.classList.contains("dark")) {
            modeText.innerText = "Светлая тема";
            localStorage.setItem("mode", "dark");
            // var home = document.getElementById("home");
            body.setAttribute("data-bs-theme", "light");
        } else {
            modeText.innerText = "Темная тема";
            localStorage.setItem("mode", "light");
            // var home = document.getElementById("home");
            body.setAttribute("data-bs-theme", "dark");
        }
    });
});
