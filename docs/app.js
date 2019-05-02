import { Elm } from "../src/SE/Framework.elm";

var app = Elm.SE.Framework.init({
  node: document.getElementById("elm-f0111bc4e658d0f98db96260c16f7e49")
});
if (document.getElementById("elm-f0111bc4e658d0f98db96260c16f7e49")) {
  document.getElementById("elm-f0111bc4e658d0f98db96260c16f7e49").innerText =
    "This is a headless program, meaning there is nothing to show here.\n\nI started the program anyway though, and you can access it as `app` in the developer console.";
}
